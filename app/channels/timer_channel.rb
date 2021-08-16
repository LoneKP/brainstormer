class TimerChannel < ApplicationCable::Channel

  def subscribed
    @brainstorm = Brainstorm.find_by(token: params[:token])
    @timer = @brainstorm.timer

    stream_from "brainstorm-#{params[:token]}-timer"
    update_redis_if_time_has_run_out
    transmit_list!
  end

  private

  def transmit_list!
    ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-timer", {
      event: "transmit_timer_status",
      timer_status: timer_status,
      brainstorm_duration: @timer.duration
    })
  end

  def timer_status
    case
    when @timer.expired? then "time_has_run_out"
    when @timer.ready?   then "ready_to_start_timer"
    else
      @timer.elapsed_seconds
    end
  end

  def update_redis_if_time_has_run_out
    @brainstorm.state = :vote if @brainstorm.state.ideation? && @timer.expired?
  end
end
