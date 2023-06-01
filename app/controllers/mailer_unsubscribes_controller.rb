class MailerUnsubscribesController < ApplicationController
  before_action :set_user, only: :show

  def show
    if @user.update(send_onboarding_emails: false)
      #do nothing else than showing the page
    else
      flash[:alert] = "There was an error unsubscribing. Navigate to your settings to unsubscribe instead."
    end
  end

  private

  def set_user
    @user = GlobalID::Locator.locate_signed params[:id]
  end

end