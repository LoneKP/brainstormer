class Mailer::SendOutUsageTipJob < ApplicationJob

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user.present?

    OnboardingMailer.with(user: user).usage_tip_email.deliver_later
  end
end