class Idea < ApplicationRecord
  belongs_to :brainstorm
  has_many :idea_builds

  validates :text, presence: {message: "You forgot to write an idea!"}

  def number
    brainstorm.ideas.index(self) + 1
  end
end
