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

  def merge_into(target_idea)

    transaction do
      # Collect attributes of idea_builds from the source idea
      idea_builds_attributes = self.idea_builds.map do |idea_build|
        { idea_build_text: idea_build.idea_build_text, author: idea_build.author }
      end

      # Add the original idea itself as an idea_build to the target idea as the first idea_build
      idea_builds_attributes.unshift( { idea_build_text: self.text, author: self.author } )

      idea_builds_attributes.each do |attributes|
        target_idea.idea_builds.create(attributes)
      end

      target_idea.update(votes: target_idea.votes + self.votes)
  
      self.destroy
    end
  end
end