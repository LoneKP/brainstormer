class IdeasMailer < ApplicationMailer

  def ideas_email
    @brainstorm = Brainstorm.find_by(token: params[:token])
    @ideas = @brainstorm.ideas.order(votes: :desc)
    headers['X-MT-Category'] = 'ideas email'
    mail(to: params[:email_address], subject: 'Result from your ideation session' )
  end
end
