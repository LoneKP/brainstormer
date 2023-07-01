module Ideated

  def broadcast_ideas(event, ideas)
    StateChannel.broadcast_to @brainstorm, { event: event, ideas: ideas }
  end

  private

  def transmit_ideas(sorting_choice, available_votes = nil)
    IdeasChannel.broadcast_to @brainstorm, { event: "transmit_ideas", ideas: ideas_and_idea_builds_object(sorting_choice), available_votes: available_votes, anonymous: @brainstorm.anonymous? }
  end

  def ideas_and_idea_builds_object(sorting_choice)
    @brainstorm.ideas.order(sorting_choice).as_json(
      methods: [:vote_in_plural_or_singular, :number],
      only: [:id, :text, :votes, :author],
      include: {
        idea_builds: {
          methods: [:vote_in_plural_or_singular, :decimal, :opacity_lookup],
          only: [:id, :idea_build_text, :votes, :author]
        }
      })
  end

  def sort_by_id_desc
    'id DESC'
  end

  def sort_by_votes_desc
    'votes DESC'
  end
end