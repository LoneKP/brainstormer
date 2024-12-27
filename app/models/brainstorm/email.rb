class Brainstorm::Email
  include ActiveModel::Validations

  attr_accessor :email_address

  validates :email_address, presence: { message: "Oops! Something went wrong" }
end