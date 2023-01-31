class Admin::HomesController < ApplicationController

  def top

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

   protected

  def post_params
    params.permit(:user_id, :category_id, :post_text, :image)
  end

end
