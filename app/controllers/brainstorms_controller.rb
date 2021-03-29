class BrainstormsController < ApplicationController
  before_action :set_brainstorm, only: [:show, :start_timer, :reset_timer, :start_brainstorm, :start_voting, :done_voting, :done_brainstorming, :download_pdf]
  before_action :set_brainstorm_ideas, only: [:show, :download_pdf]
  before_action :set_session_id, only: [:show, :create, :done_voting]
  before_action :facilitator?, only: [:show]
  before_action :facilitator_name, only: [:show]
  before_action :get_state, only: [:show]
  before_action :votes_left, only: [:show]
  before_action :set_votes_cast_count, only: [:show]
  before_action :idea_votes, only: [:show]
  before_action :idea_build_votes, only: [:show]
  before_action :user_is_done_voting?, only: [:show]

  def index
    @brainstorm = Brainstorm.new
  end

  def create
    @brainstorm = Brainstorm.new(brainstorm_params)
    @brainstorm.token = generate_token
    respond_to do |format|
      if @brainstorm.save
        REDIS.set @session_id, @brainstorm.name
        REDIS.set brainstorm_state_key, "setup"
        set_facilitator
          format.js { render :js => "window.location.href = '#{brainstorm_path(@brainstorm.token)}'" }
      else
        @brainstorm.errors.messages.each do |message|
          flash.now[message.first] = message[1].first
          format.js
        end
      end
    end
  end

  def show
    @idea = Idea.new
    @current_user_name = REDIS.get(@session_id)
  end

  def set_user_name
    respond_to do |format|
      if REDIS.set set_user_name_params[:session_id], set_user_name_params[:user_name]
          ActionCable.server.broadcast("brainstorm-#{params[:token]}-presence", { event: "name_changed", name: set_user_name_params[:user_name] })
          format.html {}
          format.js
      else
          format.html {}
          format.js
      end
    end
  end

  def send_ideas_email
    respond_to do |format|
      if IdeasMailer.with(token: params[:token], email: params[:email]).ideas_email.deliver_later
          format.html {}
          format.js
      else
          format.html {}
          format.js
      end
    end
  end

  def go_to_brainstorm
    respond_to do |format|
      if !Brainstorm.find_by(token: params[:token].sub("#", "")).nil?
        format.js { render :js => "window.location.href = '#{brainstorm_path(params[:token].sub("#", ""))}'" }
      else
          flash.now["token"] = "It looks like this ID doesn't exist"
          format.js
      end
    end
  end

  def start_timer
    respond_to do |format|
      if REDIS.hget(brainstorm_timer_running_key, "timer_start_timestamp").nil?
        ActionCable.server.broadcast("brainstorm-#{params[:token]}-timer", { event: "start_timer" })
        REDIS.hset(brainstorm_timer_running_key, "timer_start_timestamp", Time.now)
          format.js
      else
        reset_timer
        format.js
      end
    end
  end

  def reset_timer
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-timer", { event: "reset_timer" })
    REDIS.hdel(brainstorm_timer_running_key, "timer_start_timestamp")
  end

  def done_brainstorming
    start_voting
    reset_timer
  end

  def start_brainstorm
      REDIS.set(brainstorm_state_key, "ideation")
      ActionCable.server.broadcast("brainstorm-#{params[:token]}-state", { event: "set_brainstorm_state", state: "ideation" })
  end

  def start_voting
    REDIS.set(brainstorm_state_key, "vote")
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-state", { event: "set_brainstorm_state", state: "vote" })
    transmit_ideas
  end

  def done_voting
    if !user_is_done_voting?
      REDIS.hset(done_voting_brainstorm_status, user_key, "true")
      ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-presence", { event: "done_voting", state: "vote", user_id: @session_id })
      user_is_done_voting?
    else
      REDIS.hset(done_voting_brainstorm_status, user_key, "false")
      ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-presence", { event: "resume_voting", state: "vote", user_id: @session_id })
      user_is_done_voting?
    end

    if all_online_users_done_voting?
      puts "ALL USERS ARE DONE VOOOOOOOOOOOOOOOOTING"
      REDIS.set(brainstorm_state_key, "voting_done")
      ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-state", { event: "set_brainstorm_state", state: "voting_done" })
      transmit_ideas
    end
  end

  def change_state
    REDIS.set(brainstorm_state_key, params[:new_state])
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-state", { event: "set_brainstorm_state", state: params[:new_state] })
  end

  def download_pdf
    respond_to do |format|
      format.pdf do
        render pdf: "Brainstorm session ideas",
        page_size: "A4",
        template: "brainstorms/download_pdf.html.erb",
        layout: "pdf.html",
        lowquality: true,
        dpi: 75
      end
    end
  end

  private

  def all_online_users_done_voting?
    users_online = REDIS.hgetall(brainstorm_key).count
    users_done_voting = REDIS.hgetall(done_voting_brainstorm_status).count { |k,v| v=="true" }

    return true if users_online == users_done_voting
    false
  end

  def generate_token
    "BRAIN" + SecureRandom.hex(3).to_s
  end

  def set_brainstorm
    @brainstorm = Brainstorm.find_by token: params[:token]
  end

  def brainstorm_params
    params.require(:brainstorm).permit(:problem, :name)
  end

  def set_brainstorm_ideas
    @ideas = @brainstorm.ideas.order('id DESC')
  end

  def set_user_name_params
    params.require(:set_user_name).permit(:user_name, :session_id)
  end

  def set_facilitator
    REDIS.set brainstorm_facilitator_key, @session_id
  end

  def facilitator?
    @is_user_facilitator = REDIS.get(brainstorm_facilitator_key) == @session_id
  end

  def facilitator_name
    @brainstorm_facilitator_name = REDIS.get(REDIS.get(brainstorm_facilitator_key))
  end

  def brainstorm_facilitator_key
    "brainstorm_facilitator_#{@brainstorm.token}"
  end

  def brainstorm_timer_running_key
    "brainstorm_id_timer_running_#{@brainstorm.token}"
  end

  def brainstorm_state_key
    "brainstorm_state_#{@brainstorm.token}"
  end

  def get_state
    @state = REDIS.get(brainstorm_state_key)
  end

  def brainstorm_key
    "brainstorm_id_#{@brainstorm.token}"
  end

  def transmit_ideas
    ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-idea", { event: "transmit_ideas", ideas: ideas_and_idea_builds_object })
  end

  def ideas_and_idea_builds_object
    @brainstorm.ideas.order('id DESC').as_json(
      methods: [:vote_in_plural_or_singular, :number],
      only: [:id, :text, :votes], 
      include: { 
        idea_builds: {
          methods: [:vote_in_plural_or_singular, :decimal, :opacity_lookup],
          only: [:id, :idea_build_text, :votes]                                     
        }
      })
  end


end