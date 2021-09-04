class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_or_reject_for session_id
  end
end