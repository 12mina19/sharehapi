class Admin::PostsController < ApplicationController

  def index
    if params[:category_id]
      post_ids = PostCategory.where(category_id: params[:category_id]).pluck('post_id')
      # post_ids => [1,4]
      @posts = Post.where(id: post_ids)
    else
      @posts = Post.all
    end

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

  end


  protected

  def post_params
    params.permit(:user_id, :category_id, :post_text, :image)
  end
end
