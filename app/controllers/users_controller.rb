class UsersController < ApplicationController

  before_action :set_session, only: [:create]
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path
    else
      flash.now[:notice] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def new
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end