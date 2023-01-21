class Admin::UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect to admin_user_path(@user.id)#admin/user#showへ
  end


  protected

  def user_params
    params.require(:user).permit(:name, :email, :is_deleted, :is_unpermitted)
  end

end
