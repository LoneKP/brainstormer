class Brainstorm::DynamicVoteCounter

  attr_reader :brainstorm

  def initialize(brainstorm)
    @brainstorm = brainstorm
  end
  
  def votes
    case
      when brainstorm.ideas.count > 20
        8
      when brainstorm.ideas.count >= 11
        6
      when brainstorm.ideas.count <= 10
        3
    end
  end
end
