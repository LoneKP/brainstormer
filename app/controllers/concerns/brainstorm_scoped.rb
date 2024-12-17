module BrainstormScoped
  extend ActiveSupport::Concern

  included do
    before_action :scope_by_brainstorm
  end

  private

  def scope_by_brainstorm
    if token = params[:brainstorm_token] || params[:token]
      @brainstorm = Brainstorm.find_by! token: token
    end
    
  end
end
