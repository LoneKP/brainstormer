class Brainstorm::Document::GeneratePdfJob < ApplicationJob

  def perform(html, brainstorm, session_id)
    save_path = Rails.root.join("tmp/#{brainstorm.token}.pdf")
    pdf = WickedPdf.new.pdf_from_string(html)
 
      File.open(save_path, 'wb') do |file|
        file << pdf
      end

  end

  after_perform do |job|
    brainstorm = job.arguments[1]
    session_id = job.arguments[2]
    
    brainstorm.document.done(session_id)
  end
end

