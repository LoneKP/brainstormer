module Brainstorm::Timed
  def timer
    @timer ||= Brainstorm::Timer.new(self)
  end
end
