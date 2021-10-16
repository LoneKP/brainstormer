class Idea < ApplicationRecord
  belongs_to :brainstorm
  has_many :idea_builds

  validates :text, presence: {message: "You forgot to write an idea!"}

  def number
    brainstorm.ideas.order(:id).index(self) + 1
  end

  def vote_in_plural_or_singular
    votes > 1 || votes == 0 ? "votes" : "vote"
  end
end
