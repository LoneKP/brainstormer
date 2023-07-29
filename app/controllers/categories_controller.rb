class CategoriesController < ApplicationController

  before_action :authenticate_admin!
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  
  def index
    @categories = Category.all.order(name: :asc)
  end

  def new
    @category = Category.new
  end

  def show
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      respond_to do |format|
        format.html { redirect_to categories_path, notice: "Category was successfully created."  }
        format.turbo_stream
      end
      
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
    redirect_to categories_path, notice: "Category was successfully updated." 
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_path, notice: "Category was successfully destroyed." }
      format.turbo_stream
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    redirect_to root_path unless current_user && current_user.admin?
  end

  def authenticate_admin!
    # Check if the current user is an admin, redirect to root_url if not
    redirect_to root_url, alert: 'You are not authorized to access this page.' unless current_user&.admin?
  end


end