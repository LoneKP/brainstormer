class Brainstorm::Timer::ExpiryJob < ApplicationJob
  def perform(brainstorm)
    brainstorm.timer.check_expiry
  end
end
