class Brainstorm::Document

  def initialize(brainstorm)
    @brainstorm = brainstorm
  end

  def generate_pdf(html, visitor_id)
    GeneratePdfJob.perform_later(html, brainstorm, visitor_id)
    broadcast :generating, visitor_id
  end

  def done(visitor_id)
    broadcast :done, visitor_id
  end

  private

  attr_reader :brainstorm

  def broadcast(status, visitor_id)
    NotificationsChannel.broadcast_to visitor_id, { status: status }
  end

end