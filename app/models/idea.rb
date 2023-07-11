class Idea < ApplicationRecord
  belongs_to :brainstorm
  has_many :idea_builds, dependent: :destroy

  validates :text, presence: {message: "You forgot to write an idea!"}

  def number
    brainstorm.ideas.order(:id).index(self) + 1
  end

  def vote_in_plural_or_singular
    votes > 1 || votes == 0 ? "votes" : "vote"
  end

  def opacity_hash
    {1=>90, 2=>80, 3=>70, 4=>60, 5=>50, 6=>40, 7=>30, 8=>20, 9=>10}
  end

  def opacity_lookup_next_idea_build
    "-#{opacity_hash[idea_builds.count + 1] || 10}"
  end
end
