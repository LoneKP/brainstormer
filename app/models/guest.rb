class Guest < ApplicationRecord
  has_many :brainstorms, as: :facilitated_by
end