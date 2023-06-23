class DeleteAhoyVisitIps
  include Sidekiq::Job
  require 'sidekiq-scheduler'

  def perform
    Ahoy::Visit.update_all(ip: "")
  end
end
