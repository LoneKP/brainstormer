class TimerChannel < ApplicationCable::Channel

  def subscribed
    stream_or_reject_for @brainstorm = Brainstorm.find_by(token: params[:token])

    broadcast_to @brainstorm, {
      event: "transmit_timer_status",
      timer_status: @brainstorm.timer.elapsed_seconds,
      brainstorm_duration: @brainstorm.timer.duration
    }
  end
end
