class Brainstorms::Timers::DurationsController < ApplicationController
  include BrainstormScoped

  def update
    if params[:duration].to_i > 25
      @brainstorm.timer.duration = 0
    else
      @brainstorm.timer.duration = params[:duration].to_i.minutes
    end
  end
end
