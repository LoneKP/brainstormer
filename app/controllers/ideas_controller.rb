class IdeasController < ApplicationController
  def create
    @idea = Idea.new(idea_params)

    respond_to do |format|
      if @idea.save
          format.html { redirect_to @room }
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
end
