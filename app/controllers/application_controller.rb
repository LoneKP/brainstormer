class ApplicationController < ActionController::Base

  private
  
  def set_session_id
    @session_id = cookies[:user_id] ||= SecureRandom.uuid
  end
  
end
  
