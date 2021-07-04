class PagesController < ApplicationController
  def pages_template
    @page = request.path.sub("/", "")
  end
end