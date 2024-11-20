# app/models/brainstorm/timer.rb

class Brainstorm::Timer
  include Ideated, DoneVoting

  def initialize(brainstorm)
    @brainstorm = brainstorm
  end

  def duration
    get_duration_proxy || 10.minutes.to_i
  end

  def duration=(value)
    set_duration_proxy(value)
  end

  def start
    if no_timer?
      broadcast :no_timer
    else
      set_started_at(Time.now)
      check_expiry_later
      broadcast :start, duration
    end
  end

  def no_timer?
    duration == 0
  end

  def reset
    clear_started_at
    broadcast :reset
  end

  def check_expiry_later
    ExpiryJob.set(wait: duration).perform_later(brainstorm)
  end

  def check_expiry
    if expired?
      brainstorm.timer_expired
      broadcast :expired
      broadcast_ideas :transmit_ideas, transmit_ideas(sort_by_id_desc, Brainstorm::DynamicVoteCounter.new(brainstorm).votes)
      PresenceChannel.broadcast_to brainstorm, { event: :update_number_of_users_done_voting_element, users_done_voting: users_done_voting_who_are_also_online, total_users_online: total_users_online }
    end
  end

  def running?
    remaining_seconds.positive?
  end

  def expired?
    remaining_seconds.zero?
  end

  def remaining_seconds
    [ duration - elapsed_seconds, 0 ].max
  end

  def elapsed_seconds
    if started_at_time = get_started_at
      Time.now.to_i - started_at_time.to_i
    else
      0
    end
  end

  def id
    brainstorm.token
  end

  private

  attr_reader :brainstorm

  def broadcast(event, duration = nil)
    TimerChannel.broadcast_to brainstorm, { event: event, duration: duration }
  end

  # Methods to interact with Redis

  def duration_proxy_key
    "brainstorm_id_duration_#{id}"
  end

  def started_at_key
    "brainstorm_started_at_#{id}"
  end

  def get_duration_proxy
    value = REDIS_SESSION.get(duration_proxy_key)
    value.to_i if value
  end

  def set_duration_proxy(value)
    REDIS_SESSION.set(duration_proxy_key, value.to_i)
  end

  def get_started_at
    value = REDIS_SESSION.get(started_at_key)
    Time.at(value.to_i) if value
  end

  def set_started_at(time)
    timestamp = time.to_i
    REDIS_SESSION.set(started_at_key, timestamp)
  end

  def clear_started_at
    REDIS_SESSION.del(started_at_key)
  end
end
