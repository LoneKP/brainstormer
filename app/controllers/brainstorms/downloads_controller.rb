class Brainstorms::DownloadsController < ApplicationController
  include BrainstormScoped, PlanLimits

  before_action :set_access, only: [:download_pdf, :download_csv]

  def download_pdf
    return if !@access_to_export_features
    ahoy.track "Download pdf"
    visitor_id = params[:visitor_id]
    if @brainstorm.pdf.attached?
      redirect_to rails_blob_path(@brainstorm.pdf, disposition: 'attachment')
    else
      @brainstorm.document.generate_pdf(html, visitor_id)
    end
  end

  def download_csv
    return if !@access_to_export_features
    ahoy.track "Download csv"
    visitor_id = params[:visitor_id]
    if @brainstorm.csv.attached?
      redirect_to rails_blob_path(@brainstorm.csv, disposition: 'attachment')
    else
      @brainstorm.document.generate_csv(visitor_id)
    end
  end
 
  private

  def html
    render_to_string template: "brainstorms/downloads/generate_pdf", layout: "layouts/pdf"
  end

end