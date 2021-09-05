class Brainstorm::Document

  def initialize(brainstorm)
    @brainstorm = brainstorm
  end

  def generate_pdf(html, session_id)
    GeneratePdfJob.perform_later(html, brainstorm, session_id)
    broadcast :generating, session_id
  end

  def done(session_id)
    broadcast :done, session_id
  end

  private

  attr_reader :brainstorm

  def broadcast(status, session_id)
    NotificationsChannel.broadcast_to session_id, { status: status }
  end

end