module Brainstorm::Printer
  def document
    @document ||= Brainstorm::Document.new(self)
  end
end