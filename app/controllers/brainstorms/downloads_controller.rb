class Brainstorms::DownloadsController < ApplicationController
  include BrainstormScoped

  def download_pdf
    ahoy.track "Download pdf"
    session_id = params[:session_id]
    if @brainstorm.pdf.attached?
      redirect_to rails_blob_path(@brainstorm.pdf, disposition: 'attachment')
    else
      @brainstorm.document.generate_pdf(html, session_id)
    end
  end
 
  private

  def html
    render_to_string template: "brainstorms/downloads/generate_pdf", layout: "layouts/pdf"
  end

end