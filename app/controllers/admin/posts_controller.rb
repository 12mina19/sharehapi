class Admin::PostsController < ApplicationController

  def index
    #特定のユーザーに絞る
    @posts = Post.where(user_id: params[:user_id]).order(created_at: :desc)
     #↑この一行だけだとエラー(NoMethodError in Admin::Posts#index　undefined method `user')が出たため追記
    @user = User.find(params[:user_id])

    case params[:sort]
    when 'good'
      @posts = @posts.left_joins(:favorites).group(:post_id).order("count(post_id) desc")
    when 'old'
      @posts = @posts.order(created_at: :asc)
    else
      @posts = @posts.order(created_at: :desc)
    end

    @categories = Category.all
    @comments = Comment.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    #コメントを投稿するためのインスタンス変数を定義
    @categories = Category.all
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_path
    #今admin/homes#topに遷移するようにしてある
    #admin/users#showか#index(個別)のままでもいいかも
  end


  protected

  def post_params
    params.permit(:user_id, :category_id, :post_text, :image)
  end
end
