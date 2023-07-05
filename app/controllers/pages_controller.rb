class PagesController < ApplicationController
  include PlanLimits

  before_action :set_session_for_all_types, :track_path_visit
  before_action :set_access, :authenticate_user!, only: :your_brainstorms


  def pages_template
    @page = request.path.sub("/", "").gsub("-","_")
  end

  def your_brainstorms
    @most_recent_brainstorms = current_user.brainstorms.last(5).reverse
    @ready_for_ideation = current_user.brainstorms.select(&:ready_for_ideation)
    @in_progress = current_user.brainstorms.select(&:in_progress)
    @done = current_user.brainstorms.select(&:done)
  end

  def pricing
  end
end