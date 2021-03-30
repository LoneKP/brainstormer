class Idea < ApplicationRecord
  belongs_to :brainstorm
  has_many :idea_builds

  validates :text, presence: {message: "You forgot to write an idea!"}

  def number
    brainstorm_idea_number[self.id]
  end

  def vote_in_plural_or_singular
    votes > 1 || votes == 0 ? "votes" : "vote"
  end

  private

  def brainstorm_idea_number
    Hash[idea_id_range.zip number_id_range]
  end

  def idea_id_range
    (brainstorm.ideas.first.id..brainstorm.ideas.last.id)
  end

  def number_id_range
    (1..idea_id_range.count)
  end
end
