class Public::FavoritesController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.save
    redirect_to posts_path#投稿一覧へ
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
    if params[:ref] == 'favorite'
      redirect_to users_user_favorites_path#t投稿一覧へ
    else
      redirect_to posts_path
    end
  end
end
