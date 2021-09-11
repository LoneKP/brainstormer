class Brainstorm::Email
  include ActiveModel::Validations

  attr_accessor :email_address

  validates :email_address, presence: { message: "You need to type in your email." }
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP, message: "That doesn't look like a valid email address." }
end