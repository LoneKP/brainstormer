class IdeasController < ApplicationController
  before_action :set_brainstorm, only: :create

  def create
    @idea = Idea.new(idea_params)
    respond_to do |format|
      if @idea.save
          ActionCable.server.broadcast("brainstorm-#{@brainstorm.id}-idea", content: @idea, ideas_total: @brainstorm.ideas.count )
          format.html {}
          format.js
      else
          format.html {}
          format.js
      end
    end
  end

  private

  def idea_params
    params.require(:idea).permit(:text, :brainstorm_id)
  end

  def set_brainstorm
    @brainstorm = Brainstorm.find idea_params[:brainstorm_id]
  end
end
