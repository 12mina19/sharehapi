class Admin::CategoriesController < ApplicationController

  def create
    @category = Category.new
    @category = Category.new(category_params)
    @category.save
    redirect_to admin_categories_path
  end

  def index
    @category = Category.new
    #コントローラーに（@category = Category.new）かform_withのところに（model: Category.new）を書かないとparams enptyのエラー出るし、
    #text_fieldに前工程の値（Category）が初期値として無駄に表示されてしまう。
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
