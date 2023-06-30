class ApplicationMailer < ActionMailer::Base
  default from: '"Lone from Brainstormer" <lone@brainstormer.online>',
          reply_to: "hello@brainstormer.online"
  layout 'mailer'
end
