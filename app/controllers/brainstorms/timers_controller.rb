class Brainstorms::TimersController < ApplicationController
  include BrainstormScoped

  def update
    @brainstorm.timer.start
  end
end
