class Brainstorm::Timer
  include Kredis::Attributes

  kredis_integer :duration_proxy, key: ->(t) { "brainstorm_id_duration_#{t.to_kredis_id}" }

  def initialize(brainstorm)
    @brainstorm = brainstorm
  end

  def duration() = duration_proxy.value || 10.minutes.to_i
  def duration=(duration); duration_proxy.value = duration; end

  def start
    if REDIS.hget(brainstorm_timer_running_key, "timer_start_timestamp").nil?
      REDIS.hset(brainstorm_timer_running_key, "timer_start_timestamp", Time.now)
      broadcast_timer_event :start
    else
      reset
    end
  end

  def reset
    broadcast_timer_event :reset
    REDIS.hdel(brainstorm_timer_running_key, "timer_start_timestamp")
  end

  def brainstorm_timer_running_key
    "brainstorm_id_timer_running_#{brainstorm.token}"
  end

  def to_kredis_id() = brainstorm.token

  private

  attr_reader :brainstorm

  def broadcast_timer_event(event)
    ActionCable.server.broadcast("brainstorm-#{brainstorm.token}-timer", { event: "#{event}_timer", brainstorm_duration: duration })
  end
end
