class IdeasMailer < ApplicationMailer
  
  default from: 'notifier@mail.brainstormer.online'

  def ideas_email
    @brainstorm = Brainstorm.find_by(token: params[:token])
    @ideas = @brainstorm.ideas.order(votes: :desc)
    mail(to: params[:email_address], subject: 'Result from your ideation session' )
  end
end
