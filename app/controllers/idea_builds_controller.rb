class IdeaBuildsController < ApplicationController
  include Ideated

  def create
    @idea_build = IdeaBuild.new(idea_build_params)
    @idea = Idea.find(params[:idea_id])
    @brainstorm = Brainstorm.find(brainstorm_params[:brainstorm_id])
    respond_to do |format|
      if @idea_build.save
        transmit_ideas(sort_by_id_desc)
        format.js
      else
        @idea_build.errors.messages.each do |message|
          flash.now[message.first] = message[1].first
          format.js
        end
      end
    end
  end

  private

  def idea_build_params
    params.require(:idea_build).permit(:idea_id, :idea_build_text, :author).except(:brainstorm_id)
  end

  def brainstorm_params
    params.require(:idea_build).permit(:brainstorm_id).except(:idea_id, :idea_build_text)
  end

  def set_idea_build
    @idea_build = IdeaBuild.find(params[:idea_build_id])
  end
end
