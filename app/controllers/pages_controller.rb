class PagesController < ApplicationController
  before_action :set_session_for_all_types
  before_action :authenticate_user!, only: [:my_brainstorms]

  def pages_template
    @page = request.path.sub("/", "").sub("-","_")
  end

  def my_brainstorms
    @ready_for_ideation = current_user.brainstorms.select(&:ready_for_ideation)
    @in_progress = current_user.brainstorms.select(&:in_progress)
    @done = current_user.brainstorms.select(&:done)
  end

  def pricing
  end
end