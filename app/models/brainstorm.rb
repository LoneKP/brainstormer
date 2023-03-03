class Brainstorm < ApplicationRecord
  include States, Timed, Printer

  has_one_attached :pdf
  has_one_attached :csv
  has_many :ideas

  belongs_to :facilitated_by, polymorphic: true
  
  attr_accessor :name

  validates :problem, presence: { message: "You need to type in a problem to solve." }, :on => [:create, :update]
  validates :name, presence: { message: "Please let the other participants know who you are."}, :on => :create

  before_validation(on: :create) { self.token ||= generate_token }

  def self.find_sole_by_token(token)
    where("token ilike ?", "%#{token}").then do |relation|
      relation.first if relation.one?
    end
  end

  def ready_for_ideation
   state === "setup"
  end

  def in_progress
    if state === "ideation"
      true
    elsif state === "vote"
      true
    else
      false
    end
  end

  def done
   state === "voting_done"
  end

  private

  def generate_token
    "BRAIN" + SecureRandom.hex(3).to_s
  end
end
