class RedirectsController < ApplicationController
  def blog
    redirect_to 'https://www.blog.brainstormer.online', allow_other_host: true
  end
end