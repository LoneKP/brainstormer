class Brainstorm < ApplicationRecord
  has_many :ideas
  belongs_to :admin
  accepts_nested_attributes_for :admin
end
