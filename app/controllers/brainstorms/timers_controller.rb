class Brainstorms::TimersController < ApplicationController
  include BrainstormScoped

  def update
    @brainstorm.timer.start_or_reset
  end
end
