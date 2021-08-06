class Sessions::NamesController < ApplicationController
  before_action :set_session

  def update
    @session.name = session_params[:name]
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-presence", { event: "name_changed", name: session_params[:name] })
  end

  private

  def session_params
    params.require(:session).permit(:name)
  end
end
