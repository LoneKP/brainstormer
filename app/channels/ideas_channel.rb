class IdeasChannel < ApplicationCable::Channel
  def subscribed
    stream_or_reject_for Brainstorm.find_by(token: params[:token])
  end
end
