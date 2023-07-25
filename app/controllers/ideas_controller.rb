class IdeasController < ApplicationController
  include Ideated
  before_action :set_brainstorm, only: [:create]
  before_action :set_visitor_id, only: [:vote]
  before_action :set_idea, only: [:vote]

  def create
    @idea = Idea.new(idea_params)
    respond_to do |format|
      if @idea.save
          transmit_ideas(sort_by_id_desc)
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
    @idea_build = @idea.idea_builds.new
    @session = set_session_for_all_types
    respond_to do |format|
      format.js
    end
  end

  def toggle_idea_menu
    @idea = Idea.find(params[:idea_id])
    respond_to do |format|
      format.js
    end
  end

  def show_choose_idea_to_merge_into
    @source_idea = Idea.find(params[:idea_id])
    @brainstorm = @source_idea.brainstorm
    respond_to do |format|
      format.js
    end
  end

  def merge
    @source_idea = Idea.find(params[:idea_id])
    @target_idea = Idea.find(params[:target_idea_id])
    @brainstorm = @source_idea.brainstorm

    respond_to do |format|
      if @source_idea.merge_into(@target_idea)
        transmit_ideas(sort_by_id_desc)
        format.js
      end
    end
  end

  def vote
    @brainstorm = @idea.brainstorm
    @voting = Session::Voting.new(@brainstorm, @visitor_id)
    @voting.toggle_vote_for(@idea)
  end

  def destroy
    @idea = Idea.find(params[:id])
    @brainstorm = @idea.brainstorm
    if @idea.destroy
      transmit_ideas(sort_by_id_desc)
    end
  end

  private

  def idea_params
    params.require(:idea).permit(:text, :brainstorm_id, :author)
  end

  def set_brainstorm
    @brainstorm = Brainstorm.find idea_params[:brainstorm_id]
  end

  def set_idea
    @idea = Idea.find(params[:idea_id])
  end
end
