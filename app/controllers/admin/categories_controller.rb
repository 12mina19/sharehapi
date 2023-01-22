class Admin::CategoriesController < ApplicationController

  def create
    @category = Category.new
    @category = Category.new(category_params)
    @category.save
    redirect_to admin_categories_path
  end

  def index
    @categories = Category.all
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    @category.update(category_params)
    redirect_to admin_categories_path
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to admin_categories_path
  end


  protected

  def category_params
    params.require(:category).permit(:name)
  end
end
