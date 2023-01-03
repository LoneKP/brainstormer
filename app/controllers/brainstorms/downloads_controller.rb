class Brainstorms::DownloadsController < ApplicationController
  include BrainstormScoped

  def download_pdf
    ahoy.track "Download pdf"
    visitor_id = params[:visitor_id]
    if @brainstorm.pdf.attached?
      redirect_to rails_blob_path(@brainstorm.pdf, disposition: 'attachment')
    else
      @brainstorm.document.generate_pdf(html, visitor_id)
    end
  end
 
  private

  def html
    render_to_string template: "brainstorms/downloads/generate_pdf", layout: "layouts/pdf"
  end

end