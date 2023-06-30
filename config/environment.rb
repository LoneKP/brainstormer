# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.default from: '"Lone from Brainstormer" <lone@brainstormer.online>'
