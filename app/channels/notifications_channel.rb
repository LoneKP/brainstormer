class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_or_reject_for visitor_id
  end
end