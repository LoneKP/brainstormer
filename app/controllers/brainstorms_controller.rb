class BrainstormsController < ApplicationController
  before_action :set_brainstorm, only: :show
  before_action :set_brainstorm_ideas, only: :show

  def index
  end

  def new
    @brainstorm = Brainstorm.new
  end

  def create
    @admin = Admin.new(brainstorm_params[:admin_attributes])
    @admin.save
    @brainstorm = Brainstorm.new(brainstorm_params)
    @brainstorm.admin = @admin
      if @brainstorm.save
        redirect_to @brainstorm
      else
        render 'new'
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
    params.require(:brainstorm).permit(:problem, :admin_attributes =>[:name])
  end

  def set_brainstorm_ideas
    @ideas = Brainstorm.find(params[:id]).ideas.order('id DESC')
  end
end