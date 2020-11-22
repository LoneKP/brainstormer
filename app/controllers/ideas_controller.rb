class IdeasController < ApplicationController
  before_action :set_brainstorm, only: [:create]
  before_action :set_session_id, only: [:vote]
  before_action :set_idea, only: [:vote]

  def create
    @idea = Idea.new(idea_params)
    respond_to do |format|
      if @idea.save
          ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-idea", content: @idea, ideas_total: @brainstorm.ideas.count, idea_number: @idea.number, build_on_idea_link: idea_show_idea_build_form_path(@idea), event: "create_idea")
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
    set_votes_cast_count
    respond_to do |format|
      if !idea_has_a_vote? && @votes_cast < MAX_VOTES_PER_USER && !user_is_done_voting?
        add_vote
        format.js
      elsif idea_has_a_vote? && !user_is_done_voting?
        subtract_vote
        format.js
      else
        format.js { render :action => "unable_to_vote" }
      end
    end
    set_votes_cast_count
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

  def add_vote
    @idea.update(votes: @idea.votes + 1)
    REDIS.sadd(user_idea_votes_key, @idea.id)
  end

  def subtract_vote
    @idea.update(votes: @idea.votes - 1)
    REDIS.srem(user_idea_votes_key, @idea.id)
  end

  def idea_has_a_vote?
    @idea_has_a_vote = REDIS.sismember(user_idea_votes_key, @idea.id)
  end
end
