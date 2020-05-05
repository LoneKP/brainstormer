class IdeasChannel < ApplicationCable::Channel
  def subscribed
    @brainstorm = Brainstorm.find(params[:id])
    stream_from "brainstorm-#{@brainstorm.id}-idea"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
