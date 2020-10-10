class TimerChannel < ApplicationCable::Channel
  TIME_IN_TIMER = 600

  def subscribed
    @brainstorm = Brainstorm.find_by(token: params[:token])
    stream_from "brainstorm-#{params[:token]}-timer"
    transmit_list!
  end

  private

  def transmit_list!

    data = {
      event: "transmit_timer_status",
      timer_status: timer_status,
    }

    ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-timer", data)
  end

  def timer_status
    if REDIS.hget(brainstorm_timer_running_key, "timer_start_timestamp").nil?
      return "ready_to_start_timer"
    elsif timer_time_elapsed_in_seconds > TIME_IN_TIMER
      return "time_has_run_out"
    else
      return timer_time_elapsed_in_seconds
    end
  end

  def timer_time_elapsed_in_seconds
    Time.now.to_i - DateTime.parse(REDIS.hget(brainstorm_timer_running_key, "timer_start_timestamp")).to_i
  end

  def brainstorm_key
    "brainstorm_id_#{@brainstorm.token}"
  end

  def brainstorm_timer_running_key
    "brainstorm_id_timer_running_#{@brainstorm.token}"
  end
end
