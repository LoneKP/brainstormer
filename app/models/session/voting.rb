class Session::Voting
  MAX_VOTES_PER_SESSION = 6

  include Kredis::Attributes

  kredis_set :idea_votes,       typed: :integer, key: ->(v) { "user_idea_votes_#{v.session_id}_#{v.brainstorm.token}" }
  kredis_set :idea_build_votes, typed: :integer, key: ->(v) { "user_idea_build_votes_#{v.session_id}_#{v.brainstorm.token}" }

  kredis_hash :brainstorm_voting_status, typed: :boolean, key: ->(v) { "done_voting_brainstorm_status_#{v.brainstorm.token}" }

  attr_reader :brainstorm, :session_id

  def initialize(brainstorm, session_id)
    @brainstorm, @session_id = brainstorm, session_id
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
    MAX_VOTES_PER_SESSION.times do |index|
      yield Vote.new(index: index, used: index >= votes_cast)
    end
  end

  def can_vote?
    votes_left_count.positive?
  end

  def votes_left_count
    [ MAX_VOTES_PER_SESSION - votes_cast_count, 0 ].max
  end

  def votes_cast_count
    idea_votes.size + idea_build_votes.size
  end

  def finish
    brainstorm_voting_status[session_id] = true
  end

  def done?
    brainstorm_voting_status[session_id]
  end

  private

  Vote = Struct.new(:index, :used, keyword_init: true) do
    alias used? used
  end

  def votes_for(votable)
    votable.is_a?(Idea) ? idea_votes : idea_build_votes
  end
end
