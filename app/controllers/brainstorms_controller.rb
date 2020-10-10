class BrainstormsController < ApplicationController
  before_action :set_brainstorm, only: [:show, :start_timer]
  before_action :set_brainstorm_ideas, only: [:show]
  before_action :set_session_id, only: [:show, :create]
  before_action :facilitator?, only: [:show]

  def index
    @brainstorm = Brainstorm.new
  end

  def create
    @brainstorm = Brainstorm.new(brainstorm_params)
    @brainstorm.token = generate_token
    respond_to do |format|
      if @brainstorm.save
        REDIS.set @session_id, @brainstorm.name
        REDIS.srem "no_user_name", @session_id
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
  end

  def set_user_name
    respond_to do |format|
      if REDIS.set set_user_name_params[:session_id], set_user_name_params[:user_name]
          REDIS.srem "no_user_name", set_user_name_params[:session_id]
          ActionCable.server.broadcast("brainstorm-#{params[:token]}", event: "name_changed", name: set_user_name_params[:user_name] )
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
        ActionCable.server.broadcast("brainstorm-#{params[:token]}", event: "start_timer")
        REDIS.hset(brainstorm_timer_running_key, "timer_start_timestamp", Time.now)
          format.js
      else
        ActionCable.server.broadcast("brainstorm-#{params[:token]}", event: "reset_timer")
        REDIS.hdel(brainstorm_timer_running_key, "timer_start_timestamp")
          format.js
      end
    end
  end

  private

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

  def set_session_id
    if cookies[:user_id].nil?
      cookies[:user_id] = SecureRandom.uuid
      @session_id = cookies[:user_id]
    else
      @session_id = cookies[:user_id]
    end
  end

  def set_facilitator
    REDIS.set brainstorm_facilitator_key, @session_id
  end

  def facilitator?
    @is_user_facilitator = REDIS.get(brainstorm_facilitator_key) == @session_id
  end

  def brainstorm_facilitator_key
    "brainstorm_facilitator_#{@brainstorm.token}"
  end

  def brainstorm_timer_running_key
    "brainstorm_id_timer_running_#{@brainstorm.token}"
  end
end