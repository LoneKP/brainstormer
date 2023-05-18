class ApplicationMailer < ActionMailer::Base
  default from: '"Brainstormer" <hello@mail.brainstormer.online>',
          reply_to: "hello@brainstormer.online"
  layout 'mailer'
end
