class Idea < ApplicationRecord
  belongs_to :brainstorm

  validates :text, presence: {message: "You forgot to write anything!"}

  def number
    brainstorm_idea_number[self.id]
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
