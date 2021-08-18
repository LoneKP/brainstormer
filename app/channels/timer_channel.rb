class TimerChannel < ApplicationCable::Channel

  def subscribed
    stream_or_reject_for @brainstorm = Brainstorm.find_by(token: params[:token])
    @timer = @brainstorm.timer
    transmit_list!
  end

  private

  def transmit_list!
    broadcast_to @brainstorm, {
      event: "transmit_timer_status",
      timer_status: @timer.elapsed_seconds,
      brainstorm_duration: @timer.duration
    }
  end
end
