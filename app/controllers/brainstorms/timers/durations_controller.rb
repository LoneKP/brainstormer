class Brainstorms::Timers::DurationsController < ApplicationController
  include BrainstormScoped

  def update
    @brainstorm.timer.duration = params[:duration].to_i.minutes
  end
end
