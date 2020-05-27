class IdeasMailer < ApplicationMailer
  default from: 'no-reply@no-reply.com'

  def ideas_email
    @ideas = Brainstorm.find_by(token: params[:token]).ideas
    mail(to: params[:email], subject: 'Result from your ideation session' )
  end
end
