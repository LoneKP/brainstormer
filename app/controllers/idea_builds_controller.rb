class IdeaBuildsController < ApplicationController

  def create
    @idea_build = IdeaBuild.new(idea_build_params)
    @idea = Idea.find(params[:idea_id])
    @brainstorm = Brainstorm.find(brainstorm_params[:brainstorm_id])
    respond_to do |format|
      if @idea_build.save
        ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-idea", content: @idea_build, idea_build_number: "#{@idea.number}.#{@idea_build.decimal}", event: "create_idea_build", opacity: @idea_build.opacity_lookup)
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
    params.require(:idea_build).permit(:idea_id, :idea_build_text).except(:brainstorm_id)
  end

  def brainstorm_params
    params.require(:idea_build).permit(:brainstorm_id).except(:idea_id, :idea_build_text)
  end
end
