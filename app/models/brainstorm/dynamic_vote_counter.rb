class Brainstorm::DynamicVoteCounter

  attr_reader :brainstorm

  def initialize(brainstorm)
    @brainstorm = brainstorm
  end
  
  def votes
    case
      when brainstorm.ideas.size > 20
        8
      when brainstorm.ideas.size >= 10
        6
      when brainstorm.ideas.size < 9
        3
    end
  end
end
