class Brainstorms::DownloadsController < ApplicationController
  include BrainstormScoped, PlanLimits

  before_action :set_access, only: :download_pdf

  def download_pdf
    return if !@access_to_pdf_export
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