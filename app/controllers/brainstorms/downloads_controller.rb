class Brainstorms::DownloadsController < ApplicationController
  def show
    @brainstorm = Brainstorm.find_by(token: params[:token])

    ahoy.track "Download pdf"
    render pdf: "Brainstorm session ideas", layout: "pdf.html", page_size: "A4", lowquality: true, dpi: 75
  end
end
