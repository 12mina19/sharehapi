class Public::UsersController < ApplicationController

  def show
    @user = current_user
    #試しにカテゴリーの記述してみた
    @categories = Category.all
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to users_my_page_path
    else
      render :edit
    end
  end

  #退会確認画面用
  def unsubscribe
    @user = current_user
  end

  #退会処理（ステータスの更新）
  def withdraw
    @user = current_user
    @user.update(is_deleted: true) #ここでis_deletedカラムの値をtrue(退会済）に更新
    reset_session #この記述で現在のログイン状況をリセットする（destroyではない）
    flash[:notice] = "退会が完了しました。"
    redirect_to root_path #処理完了後ルートパスへ遷移
    #rootページにフラッシュメッセージの<%= notice %>を設置してみたが果たしてちゃんと処理されているだろうか…？？？
  end



  protected

  def user_params
    params.require(:user).permit(:name, :email, :is_deleted, :is_unpermitted)
  end

end
