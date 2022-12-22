class Guest < ApplicationRecord
  has_many :brainstorms, as: :facilitated_by, dependent: :destroy
end