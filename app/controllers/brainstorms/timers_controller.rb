module Brainstorm::Timed
  def timer
    @timer ||= Brainstorm::Timer.new(self)
  end
end

class Brainstorm::Timer
  include Kredis::Attributes

  kredis_integer :duration_proxy, key: ->(b) { "brainstorm_id_duration_#{b.token}" }
  kredis_datetime :started_at,    key: ->(b) { "brainstorm_id_timer_running_#{b.token}" }

  def initialize(brainstorm)
    @brainstorm = brainstorm
  end

  def duration() = duration_proxy.value
  def duration=(duration); duration_proxy.value = duration; end

  def start
    started_at.value = Time.now
  end

  def reset
    started_at.clear
  end

  def expired?
    remaining_seconds&.zero?
  end

  def remaining_seconds
    Time.now.since started_at # TODO
  end

  def status
    case
    when !started_at.exists? then :ready_to_start_timer
    when expired? then :time_has_run_out
    else
      timer_time_elapsed_in_seconds
    end
  end
end

class Brainstorms::TimersController < ApplicationController
  include BrainstormScoped

  def new
    @brainstorm.timer.duration = params[:duration]
  end

  def create
    if REDIS.hget(brainstorm_timer_running_key, "timer_start_timestamp").nil?
      ActionCable.server.broadcast("brainstorm-#{params[:token]}-timer", { event: "start_timer", brainstorm_duration: brainstorm_duration })
      REDIS.hset(brainstorm_timer_running_key, "timer_start_timestamp", Time.now)
    else
      reset_timer
    end
  end

  def destroy
    reset_timer
  end

  private

  def timer_params
    params.require(:timer).permit(:duration)
  end

  def reset_timer
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-timer", { event: "reset_timer", brainstorm_duration: REDIS.get(brainstorm_duration_key) })
    REDIS.hdel(brainstorm_timer_running_key, "timer_start_timestamp")
  end
end
