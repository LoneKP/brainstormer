class TimerChannel < ApplicationCable::Channel

  def subscribed
    @brainstorm = Brainstorm.find_by(token: params[:token])
    stream_from "brainstorm-#{params[:token]}-timer"
    update_redis_if_time_has_run_out
    transmit_list!
  end

  private

  def transmit_list!
    ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-timer", {
      event: "transmit_timer_status",
      timer_status: timer_status,
      brainstorm_duration: @brainstorm.timer.duration
    })
  end

  def timer_status
    seconds = @brainstorm.timer.elapsed_seconds

    case
    when !@brainstorm.timer.running?          then "ready_to_start_timer"
    when seconds > @brainstorm.timer.duration then "time_has_run_out"
    else
      seconds
    end
  end

  def update_redis_if_time_has_run_out
    @brainstorm.state = :vote if @brainstorm.state.ideation? && timer_status == "time_has_run_out"
  end
end
