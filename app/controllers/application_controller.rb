class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    end
  end

  private

  def set_session
    set_session_id
    @session = Session.new(@session_id)
  end

  def set_session_id
    @session_id = cookies[:guest_id] ||= SecureRandom.uuid
  end

end
