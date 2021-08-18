Rails.application.config.tap do |config|
  # Use a real queuing backend for Active Job (and separate queues per environment).
  config.active_job.queue_adapter     = :sidekiq
  config.active_job.queue_name_prefix = "brainstormer_online_#{Rails.env}"
end
