class Session::Voting
  MAX_VOTES_PER_SESSION = 6

  include Kredis::Attributes
  include Brainstorm::States, Ideated, DoneVoting

  kredis_set :idea_votes,       typed: :integer, key: ->(v) { "user_idea_votes_#{v.visitor_id}_#{v.brainstorm.token}" }
  kredis_set :idea_build_votes, typed: :integer, key: ->(v) { "user_idea_build_votes_#{v.visitor_id}_#{v.brainstorm.token}" }

  kredis_hash :brainstorm_voting_status, typed: :boolean, key: ->(v) { "done_voting_brainstorm_status_#{v.brainstorm.token}" }

  attr_reader :brainstorm, :visitor_id

  def initialize(brainstorm, visitor_id)
    @brainstorm, @visitor_id = brainstorm, visitor_id
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
    votes_for(votable).include?(votable.id)
  end

  def vote_for(votable)
    if !done? && can_vote?
      votes_for(votable) << votable.id
      votable.increment! :votes
    end
  end

  def subtract_vote_for(votable)
    unless done?
      votes_for(votable).remove votable.id
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
    [ dynamic_vote_count - votes_cast_count, 0 ].max
  end

  def votes_cast_count
    idea_votes.size + idea_build_votes.size
  end

  def finish
    brainstorm_voting_status[visitor_id] = true
  end

  def open
    brainstorm_voting_status[visitor_id] = false
  end

  def done?
    brainstorm_voting_status[visitor_id]
  end

  def toggle_voting_done
    done? ? open : finish
    broadcast_presence :update_number_of_users_done_voting_element, users_done_voting_who_are_also_online, total_users_online
    if everyone_done_voting?
      change_to_voting_done_state
    end
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

  private

  Vote = Struct.new(:index, :used, keyword_init: true) do
    alias used? used
  end

  def votes_for(votable)
    votable.is_a?(Idea) ? idea_votes : idea_build_votes
  end

  def broadcast_state(state)
    StateChannel.broadcast_to brainstorm, { event: "set_brainstorm_state", state: state }
  end  

  def broadcast_presence(event, done, online)
    PresenceChannel.broadcast_to brainstorm, {event: event, users_done_voting: done, total_users_online: online}
  end  
end
