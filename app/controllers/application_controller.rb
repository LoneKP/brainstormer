class ApplicationController < ActionController::Base
  MAX_VOTES_PER_USER = 6

  private

  def set_session
    set_session_id
    @session = Session.new(@session_id)
  end

  def set_session_id
    @session_id = cookies[:user_id] ||= SecureRandom.uuid
  end

  def idea_build_votes
    @idea_build_votes = REDIS.smembers(user_idea_build_votes_key).map(&:to_i)
  end

  def idea_votes
    @idea_votes = REDIS.smembers(user_idea_votes_key).map(&:to_i)
  end

  def user_idea_votes_key
    "user_idea_votes_#{@session_id}_#{@brainstorm.token}"
  end

  def user_idea_build_votes_key
    "user_idea_build_votes_#{@session_id}_#{@brainstorm.token}"
  end

  def user_key
    "#{@session_id}"
  end

  def done_voting_brainstorm_status
    "done_voting_brainstorm_status_#{@brainstorm.token}"
  end

  def votes_left
    @votes_left = MAX_VOTES_PER_USER-(REDIS.smembers(user_idea_votes_key).count + REDIS.smembers(user_idea_build_votes_key).count)
  end

  def set_votes_cast_count
    @votes_cast = REDIS.smembers(user_idea_votes_key).count + REDIS.smembers(user_idea_build_votes_key).count
  end

  def user_is_done_voting?
    @user_is_done_voting = REDIS.hget(done_voting_brainstorm_status, user_key) == "true"
  end
end
