web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -e production -C config/sidekiq.yml
scheduler: IS_SCHEDULER=true bundle exec sidekiq -q brainstormer_online_production_scheduler
release: rake db:migrate