class StateChannel < ApplicationCable::Channel
  def subscribed
    @brainstorm = Brainstorm.find_by(token: params[:token])
    stream_from "brainstorm-#{params[:token]}-state"
  end
end