class Brainstorms::EmailsController < ApplicationController
  include BrainstormScoped

  def create
    @email_address = current_user.email
    respond_to do |format|
      if @email_address
        IdeasMailer.with(token: params[:brainstorm_token], email_address: @email_address).ideas_email.deliver_later
        flash.now[:success] = "Your email was successfully sent to #{@email_address}"
        ahoy.track "Email sent successfully"
      else
        @email.errors.messages.each do |message|
          flash.now[message.first] = message[1].first
        end
      end
    end
  end

end