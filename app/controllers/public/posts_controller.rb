class Public::PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to posts_path
  end

  def show
  end

  def destroy
  end


  protected

  def post_params
    params.require(:post).permit(:user_id, :category_id, :post_text, :image)
  end
end
