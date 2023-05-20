class OnboardingMailer < ApplicationMailer

  def welcome_email
    mail(to: params[:email_address], subject: "A personal hello" )
  end
end
