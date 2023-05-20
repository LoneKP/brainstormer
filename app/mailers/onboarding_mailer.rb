class OnboardingMailer < ApplicationMailer

  def welcome_email
    mail(to: params[:email_address], subject: "Let's get started with Brainstormer 💡" )
    mail['X-SMTPAPI'] = { 'category' => 'welcome email' }.to_json
  end
end
