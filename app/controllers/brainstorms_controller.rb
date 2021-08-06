class BrainstormsController < ApplicationController
  before_action :set_brainstorm, only: [:show, :start_timer, :reset_timer, :start_brainstorm, :start_voting, :done_voting, :end_voting, :done_brainstorming, :download_pdf, :change_state]
  before_action :set_session_id, only: [:show, :create, :done_voting]
  before_action :votes_left, only: [:show]
  before_action :set_votes_cast_count, only: [:show]
  before_action :idea_votes, only: [:show]
  before_action :idea_build_votes, only: [:show]
  before_action :user_is_done_voting?, only: [:show]

  def index
    @brainstorm = Brainstorm.new
    @page = "index"
  end

  def new
    @brainstorm = Brainstorm.new
  end

  def create
    @brainstorm = Brainstorm.new(brainstorm_params)
    @facilitation = Facilitation.new(@brainstorm)

    respond_to do |format|
      if @brainstorm.save
        REDIS.set @session_id, @brainstorm.name
        @facilitation.brainstorm_stage.value = :setup
        @facilitation.facilitator_session_id = @session_id

        format.js { render js: "window.location.href = '#{brainstorm_path(@brainstorm.token)}'" }
      else
        @brainstorm.errors.messages.each do |message|
          flash.now[message.first] = message[1].first
          format.js
        end
      end
    end
  end

  def show
    @ideas = @brainstorm.ideas
    @idea  = @ideas.new

    @current_facilitator = @facilitation.facilitated_by_session?(@session_id)
    @current_user_name   = @facilitation.facilitator_name
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
    if IdeasMailer.with(token: params[:token], email: params[:email]).ideas_email.deliver_later
      flash.now[:success] = "Your email was successfully sent to #{params[:email]}"
      ahoy.track "Email sent successfully"
    else
      flash.now[:error] = "Sorry! Something went wrong, and we can't send your email right now."
      ahoy.track "Email sent error"
    end
  end

  def go_to_brainstorm
    token = params[:token].remove("#")
    brainstorm = Brainstorm.find_sole_by_token(token)

    respond_to do |format|
      if !brainstorm.nil? && token.length >= 6
        format.js { render :js => "window.location.href = '#{brainstorm_path(brainstorm.token)}'" }
      elsif token.length == 0
        flash.now["token"] = "You forgot to write an ID! If you don't have one you should ask the facilitator"
        format.js
      elsif token.length < 6
        flash.now["token"] = "It looks like this ID is too short"
        format.js
      else
        flash.now["token"] = "It looks like this ID doesn't exist"
        format.js
      end
    end
  end

  def start_timer(brainstorm_duration = "already_set")
    unless brainstorm_duration == "already_set"
      REDIS.set(brainstorm_duration_key, brainstorm_duration)
    end
    respond_to do |format|
      if REDIS.hget(brainstorm_timer_running_key, "timer_start_timestamp").nil?
        ActionCable.server.broadcast("brainstorm-#{params[:token]}-timer", { event: "start_timer", brainstorm_duration: brainstorm_duration })
        REDIS.hset(brainstorm_timer_running_key, "timer_start_timestamp", Time.now)
          format.js
      else
        reset_timer
        format.js
      end
    end
  end

  def reset_timer
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-timer", { event: "reset_timer", brainstorm_duration: REDIS.get(brainstorm_duration_key) })
    REDIS.hdel(brainstorm_timer_running_key, "timer_start_timestamp")
  end

  def done_brainstorming
    start_voting
    reset_timer
  end

  def start_brainstorm
    @facilitation.brainstorm_stage.value = :ideation
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-state", { event: "set_brainstorm_state", state: "ideation" })
    start_timer(params[:brainstorm_duration])
  end

  def start_voting
    @facilitation.brainstorm_stage.value = :vote
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-state", { event: "set_brainstorm_state", state: "vote" })
    transmit_ideas(sort_by_id_desc)
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
      end_voting
    end
  end

  def end_voting
    @facilitation.brainstorm_stage.value = :voting_done
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-presence", { event: "remove_done_tags_on_user_badges" })
    ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-state", { event: "set_brainstorm_state", state: "voting_done" })
    transmit_ideas(sort_by_votes_desc)
  end

  def change_state
    @facilitation.brainstorm_stage.value = params[:new_state].to_sym
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-state", { event: "set_brainstorm_state", state: params[:new_state] })
  end

  class Facilitation
    def initialize(brainstorm)
      @brainstorm = brainstorm
    end

    def brainstorm_stage
      @brainstorm_stage ||= Kredis.enum("brainstorm_state_#{@brainstorm.token}", values: %i[ setup ideation vote voting_done ], default: nil)
    end


    def facilitator_session_id=(session_id)
      facilitator.value = session_id
    end

    def facilitated_by_session?(session_id)
      facilitator.value == session_id
    end

    def facilitator_name
      Kredis.proxy(facilitator.value).get
    end

    private

    def facilitator
      @facilitator ||= Kredis.string("brainstorm_facilitator_#{@brainstorm.token}")
    end
  end

  private

  def all_online_users_done_voting?
    users_online = REDIS.hgetall(brainstorm_key).count
    users_done_voting = REDIS.hgetall(done_voting_brainstorm_status).count { |k,v| v=="true" }

    return true if users_online == users_done_voting
    false
  end

  def set_brainstorm
    @brainstorm   = Brainstorm.find_by token: params[:token]
    @facilitation = Facilitation.new(@brainstorm)
  end

  def brainstorm_params
    params.require(:brainstorm).permit(:problem, :name)
  end

  def set_user_name_params
    params.require(:set_user_name).permit(:user_name, :session_id)
  end

  def brainstorm_timer_running_key
    "brainstorm_id_timer_running_#{@brainstorm.token}"
  end

  def brainstorm_duration_key
    "brainstorm_id_duration_#{@brainstorm.token}"
  end

  def brainstorm_key
    "brainstorm_id_#{@brainstorm.token}"
  end

  def transmit_ideas(sorting_choice)
    ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-idea", { event: "transmit_ideas", ideas: ideas_and_idea_builds_object(sorting_choice) })
  end

  def ideas_and_idea_builds_object(sorting_choice)
    @brainstorm.ideas.order(sorting_choice).as_json(
      methods: [:vote_in_plural_or_singular, :number],
      only: [:id, :text, :votes],
      include: {
        idea_builds: {
          methods: [:vote_in_plural_or_singular, :decimal, :opacity_lookup],
          only: [:id, :idea_build_text, :votes]
        }
      })
  end

  def sort_by_id_desc
    'id DESC'
  end

  def sort_by_votes_desc
    'votes DESC'
  end
end
