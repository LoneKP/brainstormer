class ApplicationController < ActionController::Base
  include PlanLimits

  before_action :set_visitor_id
  before_action :set_return_path


  def set_return_path
    return if devise_controller? || !request.method === "GET" || request.url === root_url 

    store_location_for(:user, request.url)
  end
  
  private

  def set_current_facilitator
    if @brainstorm.facilitated_by_type === "Guest"
      Current.facilitator = Guest.find_by(id: @session.guest_id) if @brainstorm.facilitated_by === Guest.find_by(id: @session.guest_id)
    elsif @brainstorm.facilitated_by_type === "User"
      Current.facilitator = User.find_by(id: @session.user_id) if @brainstorm.facilitated_by === User.find_by(id: @session.user_id)
    end
  end

  def set_session_for_all_types
    set_visitor_id
    set_current_guest
    @session ||= Session.new(@visitor_id, @current_guest&.id, current_user&.id)
  end

  def set_visitor_id
    @visitor_id = cookies[:visitor_id] ||= SecureRandom.uuid
  end

  def set_current_guest
    if !current_user
      @current_guest ||= Guest.find(session[:guest_id]) if session[:guest_id]
    end
  end

  def set_portal_session
    return if current_user.payment_processor.nil?
    @portal_session = current_user.payment_processor.billing_portal
  end

  def set_access
    unless @brainstorm.nil?
      @access_to_brainstorms_duration = plan_data(:access_to_brainstorm_duration, @brainstorm.facilitated_by.plan)
      @access_to_export_features = plan_data(:access_to_export_features, @brainstorm.facilitated_by.plan)
    end
    unless current_user.nil?
      @access_to_your_brainstorms = plan_data(:access_to_your_brainstorms, current_user.plan)
    end
  end

  def track_path_visit
    page = request.path.sub("/", "").empty? ? "front page" : request.path.sub("/", "")
    ahoy.track "Visit on #{page}" 
  end
end
