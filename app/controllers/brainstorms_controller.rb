class BrainstormsController < ApplicationController
  before_action :set_brainstorm, only: :show
  before_action :set_brainstorm_ideas, only: :show

  def index
    @brainstorm = Brainstorm.new
  end

  def create
    @brainstorm = Brainstorm.new(filtered_brainstorm_params)
      if @brainstorm.save
        redirect_to brainstorm_path(@brainstorm, name: brainstorm_params[:name])
      else
        render :root
    end
  end

  def show
    @idea = Idea.new
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
    @ideas = Brainstorm.find(params[:id]).ideas.order('id DESC')
  end
end