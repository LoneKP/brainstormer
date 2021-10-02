class Sessions::NamesController < ApplicationController
  include BrainstormScoped
  before_action :set_session

  def update
    @session.name = session_params[:name]
    PresenceChannel.broadcast_to @brainstorm, { event: "name_changed", name: session_params[:name] }
  end

  private

  def session_params
    params.require(:session).permit(:name)
  end
end
