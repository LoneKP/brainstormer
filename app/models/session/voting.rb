# app/models/session/voting.rb

class Session::Voting
  MAX_VOTES_PER_SESSION = 6

  include Brainstorm::States, Ideated, DoneVoting

  attr_reader :brainstorm, :visitor_id

  def initialize(brainstorm, visitor_id)
    @brainstorm = brainstorm
    @visitor_id = visitor_id
  end

  def dynamic_vote_count
    Brainstorm::DynamicVoteCounter.new(brainstorm).votes
  end

  def toggle_vote_for(votable)
    unless done?
      voted_for?(votable) ? subtract_vote_for(votable) : vote_for(votable)
    end
  end

  def voted_for?(votable)
    idea_voted_for?(votable.id)
  end

  def vote_for(votable)
    if !done? && can_vote?
      add_idea_vote(votable.id)
      votable.increment! :votes
    end
  end

  def subtract_vote_for(votable)
    unless done?
      remove_idea_vote(votable.id)
      votable.decrement! :votes
    end
  end

  def each_available_vote
    votes_cast = votes_cast_count
    dynamic_vote_count.times do |index|
      yield Vote.new(index: index, used: index >= votes_cast)
    end
  end

  def can_vote?
    votes_left_count.positive?
  end

  def votes_left_count
    [dynamic_vote_count - votes_cast_count, 0].max
  end

  def votes_cast_count
    idea_votes_size
  end

  def finish
    set_brainstorm_voting_status(visitor_id, true)
  end

  def open
    set_brainstorm_voting_status(visitor_id, false)
  end

  def done?
    get_brainstorm_voting_status(visitor_id)
  end

  def toggle_voting_done
    done? ? open : finish
    broadcast_presence :update_number_of_users_done_voting_element, users_done_voting_who_are_also_online, total_users_online
    #PresenceChannel.broadcast_to brainstorm, { event: "toggle_done_voting_badge", state: "vote", user_id: visitor_id }
    # Uncomment and implement if needed
    # change_to_voting_done_state if everyone_done_voting?
  end

  def everyone_done_voting?
    users_done_voting_who_are_also_online.to_i >= total_users_online.to_i
  end

  def change_to_voting_done_state
    brainstorm.state = :voting_done
    broadcast_state :voting_done
    broadcast_ideas :transmit_ideas, transmit_ideas(sort_by_votes_desc)
    PresenceChannel.broadcast_to brainstorm, { event: "remove_done_tags_on_user_badges" }
  end

  def idea_votes
    REDIS_SESSION.smembers(idea_votes_key).map(&:to_i)
  end

  private

  Vote = Struct.new(:index, :used, keyword_init: true) do
    alias_method :used?, :used
  end

  # Redis methods for idea_votes
  def idea_votes_key
    "user_idea_votes_#{visitor_id}_#{brainstorm.token}"
  end

  def idea_votes_size
    REDIS_SESSION.scard(idea_votes_key)
  end

  def add_idea_vote(idea_id)
    REDIS_SESSION.sadd(idea_votes_key, idea_id)
  end

  def remove_idea_vote(idea_id)
    REDIS_SESSION.srem(idea_votes_key, idea_id)
  end

  def idea_voted_for?(idea_id)
    REDIS_SESSION.sismember(idea_votes_key, idea_id)
  end

  # Redis methods for brainstorm_voting_status
  def brainstorm_voting_status_key
    "done_voting_brainstorm_status_#{brainstorm.token}"
  end

  def set_brainstorm_voting_status(visitor_id, status)
    REDIS_SESSION.hset(brainstorm_voting_status_key, visitor_id, status ? 'true' : 'false')
  end

  def get_brainstorm_voting_status(visitor_id)
    value = REDIS_SESSION.hget(brainstorm_voting_status_key, visitor_id)
    value == 'true'
  end

  def all_brainstorm_voting_statuses
    REDIS_SESSION.hgetall(brainstorm_voting_status_key).transform_values { |v| v == 'true' }
  end

  # Placeholder methods for broadcasting (implement as needed)
  def broadcast_state(state)
    StateChannel.broadcast_to brainstorm, { event: "set_brainstorm_state", state: state }
  end

  def broadcast_presence(event, done, online)
    PresenceChannel.broadcast_to brainstorm, { event: event, users_done_voting: done, total_users_online: online }
  end
end
