class TimerChannel < ApplicationCable::Channel

  def subscribed
    @brainstorm = Brainstorm.find_by(token: params[:token])
    @timer = @brainstorm.timer

    stream_from "brainstorm-#{params[:token]}-timer"
    move_to_vote_if_timer_expired
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
    @timer.expired? ? "time_has_run_out" : @timer.elapsed_seconds
  end

  def move_to_vote_if_timer_expired
    @brainstorm.state = :vote if @brainstorm.state.ideation? && @timer.expired?
  end
end
