class Brainstorm::Document::DeletePdfJob < ApplicationJob
  def perform(brainstorm)
    file_path = Rails.root.join("public/export/#{brainstorm.token}.pdf")
    File.delete(file_path)
  end
end