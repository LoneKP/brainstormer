class Brainstorm < ApplicationRecord
  include Facilitated, States, Timed, Printer

  has_one_attached :pdf
  has_many :ideas
  attr_accessor :name

  validates :problem, presence: { message: "You need to type in a problem to solve." }
  validates :name, presence: { message: "Please let the other participants know who you are."}

  before_validation(on: :create) { self.token ||= generate_token }

  def self.find_sole_by_token(token)
    where("token ilike ?", "%#{token}").then do |relation|
      relation.first if relation.one?
    end
  end

  private

  def generate_token
    "BRAIN" + SecureRandom.hex(3).to_s
  end
end
