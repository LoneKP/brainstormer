class OnboardingMailer < ApplicationMailer
  has_history
  utm_params
  before_action :set_user
  before_action :set_unsubscribe_url
  track_clicks campaign: "Onboarding emails"

  def welcome_email 
    if @user.agree_to_brainstormer_updates?
      headers['X-MT-Category'] = 'welcome email'
      mail(
        to: @user.email, 
        subject: "Let's get started with Brainstormer 💡" 
      )
    end
  end

  def usage_tip_email
    if @user.agree_to_brainstormer_updates?
      headers['X-MT-Category'] = 'Usage tip email'
      mail(
        to: @user.email, 
        subject: "Just checking in: How's it going with brainstormer? 🧠",
      )
    end
  end

  def free_trial_email
    if @user.agree_to_brainstormer_updates? && !@user.has_received_free_trial_email?
      headers['X-MT-Category'] = 'Free trial email'
      mail(
        to: @user.email, 
        subject: "Want to try a free trial? 😍",
      )
    end
  end

  private

  def set_unsubscribe_url
    @unsubscribe_url = mailer_unsubscribe_url(@user.to_sgid.to_s)
  end

  def set_user
    @user = params[:user]
  end
end
