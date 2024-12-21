source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

gem 'google-cloud-storage'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '7.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.4', '>= 1.4.5'
# Use Puma as the app server
gem 'puma'
# Use Sidekiq as the Active Job adapter
gem 'sidekiq', '< 8'
gem 'sidekiq-scheduler'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'ahoy_matey'
gem "ahoy_email"
gem 'maxminddb'
gem 'geoip'
gem 'geocoder'
gem 'blazer'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'csv'
gem 'mutex_m'

gem 'turbo-rails'

gem 'sprockets-rails'

gem 'devise', '~> 4.9', '>= 4.9.3'

#added after updating to ruby 3.1.2
gem 'net-smtp' # to send email
gem 'net-imap' # for rspec
gem 'net-pop'  # for rspec

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# Use Redis adapter to run Action Cable in production
gem 'redis', "~> 5.2"
gem 'redis-client', '~> 0.23.0'
gem 'redis-rails'

gem 'stripe', '~> 12.6'
gem 'pay', '~> 7.3'

gem 'omniauth', '~> 2.1', '>= 2.1.2'
gem 'omniauth-google-oauth2', '~> 1.2'
gem 'omniauth-rails_csrf_protection', '~> 1.0', '>= 1.0.2'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.8'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "letter_opener"
  gem "letter_opener_web"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'rexml'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "jsbundling-rails", "~> 1.3"
