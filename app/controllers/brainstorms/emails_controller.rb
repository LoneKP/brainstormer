class Brainstorms::EmailsController < ApplicationController
  include BrainstormScoped

  def create
    @email = Brainstorm::Email.new
    @email.email_address = params[:email_address]
    respond_to do |format|
      if @email.valid? 
        IdeasMailer.with(token: params[:brainstorm_token], email_address: @email.email_address).ideas_email.deliver_later
        flash.now[:success] = "Your email was successfully sent to #{@email.email_address}"
        ahoy.track "Email sent successfully"
        format.js
      else
        @email.errors.messages.each do |message|
          flash.now[message.first] = message[1].first
          format.js
        end
      end
    end
  end

end