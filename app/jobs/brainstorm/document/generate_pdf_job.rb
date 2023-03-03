class Brainstorm::Document::GeneratePdfJob < ApplicationJob

  def perform(html, brainstorm, visitor_id)

    brainstorm_pdf = WickedPdf.new.pdf_from_string(html)

    brainstorm.pdf.attach(io: StringIO.new(brainstorm_pdf), filename: "#{brainstorm.token}.pdf", content_type: "application/pdf")
    brainstorm.pdf.save
  end

  after_perform do |job|
    brainstorm = job.arguments[1]
    visitor_id = job.arguments[2]
    
    brainstorm.document.done(visitor_id, :pdf)
  end
end

