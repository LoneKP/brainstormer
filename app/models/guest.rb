class Guest < ApplicationRecord
  has_many :brainstorms, as: :facilitated_by, dependent: :destroy

  def plan
    1
  end

  def facilitator_plan?
    false
  end
end