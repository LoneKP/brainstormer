# Preview all emails at http://localhost:3000/rails/mailers/ideas_mailer
class IdeasMailerPreview < ActionMailer::Preview
  def ideas_email
    IdeasMailer.with(token: Brainstorm.last.token).ideas_email
  end
end
