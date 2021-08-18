class Brainstorm::Timer
  include Kredis::Attributes

  kredis_integer  :duration_proxy, key: ->(t) { "brainstorm_id_duration_#{t.id}" }
  kredis_datetime :started_at

  def initialize(brainstorm)
    @brainstorm = brainstorm

    if previous_started_at = Kredis.hash("brainstorm_id_timer_running_#{id}").hget("timer_start_timestamp").presence
      started_at.value = DateTime.parse(previous_started_at)
    end
  end

  def duration() = duration_proxy.value || 10.minutes.to_i
  def duration=(duration); duration_proxy.value = duration; end

  def start_or_reset
    running? ? reset : start
  end

  def start
    started_at.value = Time.now
    broadcast :start
  end

  def reset
    started_at.clear
    broadcast :reset
  end


  def running?
    started_at.exists?
  end

  def expired?
    elapsed_seconds > duration
  end

  def elapsed_seconds
    if value = started_at.value
      Time.now.to_i - value.to_i
    else
      0
    end
  end


  def id() = brainstorm.token

  private

  attr_reader :brainstorm

  def broadcast(event)
    TimerChannel.broadcast_to brainstorm, { event: "#{event}_timer", brainstorm_duration: duration }
  end
end
