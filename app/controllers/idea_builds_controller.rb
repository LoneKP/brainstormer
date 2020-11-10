class IdeaBuildsController < ApplicationController
  before_action :set_session_id, only: [:vote]
  before_action :set_idea_build, only: [:vote]

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

  def vote
    @idea = Idea.find(params[:idea_id])
    @brainstorm = @idea.brainstorm
    respond_to do |format|
      if !idea_build_has_a_vote? && votes_cast < MAX_VOTES_PER_USER
        add_idea_build
        format.js
      elsif idea_build_has_a_vote?
        subtract_idea_build
        format.js
      end
    votes_cast
    format.js { render :action => "unable_to_vote" }
    end
  end

  private

  def idea_build_params
    params.require(:idea_build).permit(:idea_id, :idea_build_text).except(:brainstorm_id)
  end

  def brainstorm_params
    params.require(:idea_build).permit(:brainstorm_id).except(:idea_id, :idea_build_text)
  end

  def set_idea_build
    @idea_build = IdeaBuild.find(params[:idea_build_id])
  end

  def idea_build_has_a_vote?
    @idea_build_has_a_vote = REDIS.sismember(user_idea_build_votes_key, @idea_build.id)
  end

  def add_idea_build
    @idea_build.update(votes: @idea_build.votes + 1)
    REDIS.sadd(user_idea_build_votes_key, @idea_build.id)
  end

  def subtract_idea_build
    @idea_build.update(votes: @idea_build.votes - 1)
    REDIS.srem(user_idea_build_votes_key, @idea_build.id)
  end
end
