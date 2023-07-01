class Brainstorms::SettingsController < ApplicationController
  include BrainstormScoped

  def update
    @brainstorm.update(anonymous: params[:anonymous])
  end

end