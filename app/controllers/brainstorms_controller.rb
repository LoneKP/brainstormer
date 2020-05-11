class BrainstormsController < ApplicationController
  before_action :set_brainstorm, only: [:show, :enter_brainstorm]
  before_action :set_brainstorm_ideas, only: :show
  before_action :set_session_id, only: [:show, :create, :enter_brainstorm]

  def index
    @brainstorm = Brainstorm.new
  end

  def create
    @brainstorm = Brainstorm.new(filtered_brainstorm_params)
    name = brainstorm_params[:name]
      if @brainstorm.save
        redirect_to @brainstorm
        REDIS.set @session_id, name
      else
        render :root
    end
  end

  def show
    if REDIS.get(@session_id).nil?
      redirect_to enter_brainstorm_path
    end
    @idea = Idea.new
  end

  def enter_brainstorm; end

  def set_user_name
    if REDIS.set params[:session_id], params[:user_name]
      redirect_to Brainstorm.find params[:brainstorm_id]
    else
      render 'enter_brainstorm'
    end
  end

  private

  def set_brainstorm
    @brainstorm = Brainstorm.find params[:id]
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