class PagesController < ApplicationController
  include PlanLimits

  before_action :set_session_for_all_types
  before_action :authenticate_user!, only: [:your_brainstorms]
  before_action :set_access, only: :your_brainstorms

  def pages_template
    @page = request.path.sub("/", "").sub("-","_")
  end

  def your_brainstorms
    @most_recent_brainstorms = current_user.brainstorms.last(5)
    @ready_for_ideation = current_user.brainstorms.select(&:ready_for_ideation)
    @in_progress = current_user.brainstorms.select(&:in_progress)
    @done = current_user.brainstorms.select(&:done)
    ahoy.track "your_brainstorms_page"
  end

  def pricing
    ahoy.track "pricing_page"
  end
end