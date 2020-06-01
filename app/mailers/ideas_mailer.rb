class IdeasMailer < ApplicationMailer
  default from: 'brainstormer.online@gmail.com'

  def ideas_email
    @brainstorm = Brainstorm.find_by(token: params[:token])
    @ideas = @brainstorm.ideas.order(likes: :desc)
    mail(to: params[:email], subject: 'Result from your ideation session' )
  end
end
