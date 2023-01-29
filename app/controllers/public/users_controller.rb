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
    @categories = Category.all
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

  #ログインユーザーのみの投稿一覧
  def user_index
    @user = current_user
    @posts = @user.posts
    @categories = Category.all
  end

  #ログインユーザーの投稿削除機能
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_user_index_path
    #user_indexの時点でログインユーザー（投稿者）のみの表示にしてあるため、ここのアクション・Viewでは特に制限かけていない。
  end

  #ログインユーザーのみのいいね一覧
  # def myfavorites
  def user_favorites
    @user = current_user
    @favorites = Favorite.where(user_id: @user.id)
    @categories = Category.all
  end



  protected

  def user_params
    params.require(:user).permit(:name, :email, :is_deleted, :is_unpermitted)
  end

end
