class IdeasController < ApplicationController
  before_action :set_brainstorm, only: [:create]
  before_action :set_session_id, only: [:vote]
  before_action :set_idea, only: [:vote]

  def create
    @idea = Idea.new(idea_params)
    respond_to do |format|
      if @idea.save
          IdeasChannel.broadcast_to @brainstorm, { content: @idea, ideas_total: @brainstorm.ideas.count, idea_number: @idea.number, build_on_idea_link: idea_show_idea_build_form_path(@idea), event: "create_idea" }
        format.js
      else
        @idea.errors.messages.each do |message|
          flash.now[message.first] = message[1].first
          format.js
        end
        format.js
      end
    end
  end

  def show_idea_build_form
    @idea = Idea.find(params[:idea_id])
    @brainstorm = @idea.brainstorm
    @idea_build = IdeaBuild.new
    respond_to do |format|
      format.js
    end
  end

  def vote
    @brainstorm = @idea.brainstorm
    @voting = Session::Voting.new(@brainstorm, @session_id)
    @voting.toggle_vote_for(@idea)
  end

  private

  def idea_params
    params.require(:idea).permit(:text, :brainstorm_id)
  end

  def set_brainstorm
    @brainstorm = Brainstorm.find idea_params[:brainstorm_id]
  end

  def set_idea
    @idea = Idea.find(params[:idea_id])
  end
end
