class Brainstorm::Document

  def initialize(brainstorm)
    @brainstorm = brainstorm
  end

  def generate_pdf(html, visitor_id)
    GeneratePdfJob.perform_later(html, brainstorm, visitor_id)
    broadcast :generating, visitor_id, :pdf
  end

  def generate_csv(visitor_id)
    GenerateCsvJob.perform_later(brainstorm, visitor_id)
    broadcast :generating, visitor_id, :csv
  end

  def done(visitor_id, type)
    broadcast :done, visitor_id, type
  end

  private

  attr_reader :brainstorm

  def broadcast(status, visitor_id, type)
    NotificationsChannel.broadcast_to visitor_id, { status: status, type: type }
  end

end