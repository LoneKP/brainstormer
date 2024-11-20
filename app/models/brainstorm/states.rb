module Brainstorm::States
  extend ActiveSupport::Concern

  STATES = %i[ setup ideation vote voting_done ]

  def state
    current_state = redis_get_state
    current_state.to_s.inquiry
  end

  def state=(new_state)
    new_state = new_state.to_s
    if STATES.include?(new_state.to_sym)
      redis_set_state(new_state)
    else
      raise ArgumentError, "Invalid state: #{new_state}"
    end
  end


  private

  def redis_state_key
    "brainstorm_state_#{token}"
  end

  def redis_get_state
    REDIS_SESSION.get(redis_state_key)
  end

  def redis_set_state(state)
    REDIS_SESSION.set(redis_state_key, state)
  end
end
