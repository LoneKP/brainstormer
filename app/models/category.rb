class Category < ApplicationRecord
  has_and_belongs_to_many :brainstorms

  validates :name, presence: true, uniqueness: true
end
