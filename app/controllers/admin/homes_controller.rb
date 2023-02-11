class Admin::HomesController < ApplicationController

  def top
    @posts = Post.where(params[:user_id]).order(created_at: :desc)
   ##特定のユーザーに絞るのではなく、全ユーザーの投稿が表示されるようにparams[:user_id]だけを記述
    # @posts = Post.where(user_id: params[:user_id]).order(created_at: :desc)

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

  protected

  def post_params
    params.permit(:user_id, :category_id, :post_text, :image)
  end

end
