class Brainstorm < ApplicationRecord
  has_many :ideas
  attr_accessor :name

  validates :problem, presence: { message: "You need to type in a problem to solve." }
  validates :name, presence: { message: "Please let the other participants know who you are."}

  before_validation(on: :create) { self.token ||= generate_token }

  private

  def generate_token
    "BRAIN" + SecureRandom.hex(3).to_s
  end
end
