class Mailer::SendFreeTrialJob < ApplicationJob
  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user.present?
    OnboardingMailer.with(user: user).free_trial_email.deliver_later
  end
end