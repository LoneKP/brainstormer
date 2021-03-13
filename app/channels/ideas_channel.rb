class IdeasChannel < ApplicationCable::Channel
  def subscribed
    @brainstorm = Brainstorm.find_by(token: params[:token])
    stream_from "brainstorm-#{@brainstorm.token}-idea"
  end
end
