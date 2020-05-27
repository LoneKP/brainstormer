class BrainstormsController < ApplicationController
  before_action :set_brainstorm, only: [:show, :start_timer]
  before_action :set_brainstorm_ideas, only: [:show]
  before_action :set_session_id, only: [:show, :create]

  def index
    @brainstorm = Brainstorm.new
  end

  def create
    @brainstorm = Brainstorm.new(filtered_brainstorm_params)
    @brainstorm.token = generate_token
    name = brainstorm_params[:name]
    respond_to do |format|
      if @brainstorm.save
        REDIS.set @session_id, name
          format.js { render :js => "window.location.href = '#{brainstorm_path(@brainstorm.token)}'" }
      else
          format.html { render action: "root"}
          format.js
      end
    end
  end

  def show
    @idea = Idea.new
  end

  def set_user_name
    respond_to do |format|
      if REDIS.set params[:session_id], params[:user_name]
          REDIS.srem "no_user_name", params[:session_id]
          ActionCable.server.broadcast("brainstorm-#{params[:token]}", event: "name_changed" )
          format.html {}
          format.js
      else
          format.html {}
          format.js
      end
    end
  end

  def go_to_brainstorm
    redirect_to brainstorm_path(params[:token].sub("#", ""))
  end

  def start_timer
    respond_to do |format|
      if @brainstorm.timer_running? == false
        ActionCable.server.broadcast("brainstorm-#{params[:token]}", event: "start_timer")
        @brainstorm.timer_running = !@brainstorm.timer_running?
        @brainstorm.save
          format.html {}
          format.js
      else
        ActionCable.server.broadcast("brainstorm-#{params[:token]}", event: "reset_timer")
        @brainstorm.timer_running = !@brainstorm.timer_running?
        @brainstorm.save
          format.html {}
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

  def filtered_brainstorm_params
    brainstorm_params.except(:name)
  end

  def set_brainstorm_ideas
    @ideas = @brainstorm.ideas.order('id DESC')
  end

  def set_session_id
    @session_id = request.session.id
  end
end