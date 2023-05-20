class OnboardingMailer < ApplicationMailer

  def welcome_email
    headers['X-MT-Category'] = 'welcome email'
    mail(to: params[:email_address], subject: "Let's get started with Brainstormer 💡" )
  end
end
