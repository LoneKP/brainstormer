class Brainstorms::DownloadsController < ApplicationController
  layout "pdf"

  def show
    @brainstorm = Brainstorm.find_by(token: params[:token])

    ahoy.track "Download pdf"
    render pdf: "Brainstorm session ideas", page_size: "A4", lowquality: true, dpi: 75
  end
end
