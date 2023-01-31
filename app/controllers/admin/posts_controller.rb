class Admin::PostsController < ApplicationController

  def index
    #特定のユーザーに絞る
    @posts = Post.where(user_id: params[:user_id]).order(created_at: :desc)

    # if params[:category_id]
    #   post_ids = PostCategory.where(category_id: params[:category_id]).pluck('post_id')
    #   # post_ids => [1,4]
    #   @posts = @posts.where(id: post_ids)
    # end

    case params[:sort]
    when 'good'
      @posts = @posts.joins(:favorites).group(:post_id).order("count(post_id) desc")
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
    # admin/homes#topに遷移するのはエラーでなかった

    # redirect_to admin_posts_path(user_id: params[:user_id])
    # redirect_to admin_posts_path(params[:user_id])
    # 2つだとadmin/post#indexで何も表示されなかった。

    # redirect_to admin_post_path(params[:id])×(@post.id)×


    #削除後、本当はadmin/users#showか#index（個別）のままがいいが、うまく遷移していない
  end


  protected

  def post_params
    params.permit(:user_id, :category_id, :post_text, :image)
  end
end
