class Public::HomesController < ApplicationController

  def top
    if params[:category_id]
      post_ids = PostCategory.where(category_id: params[:category_id]).pluck('post_id')
      # post_ids => [1,4]
      @posts = Post.where(id: post_ids)
    else
      @posts = Post.all
    end

    case params[:sort]
    when 'good'
      # @posts = @posts.left_joins(:favorites).group(:post_id).order("count(post_id) desc")
      #これだと、いいねが０個の時に正しく表示されない（表示されない”いいね０”があった）
      @posts = @posts.includes(:favorites).sort {|a,b| b.favorites.size <=> a.favorites.size}
      #これに書き換えることによって、いいね０個の時に正しく表示されるようになった。
      #この式の意味は、a.b.cをPostに見立てて、その中の”いいねの数”をa.b.cで順番に比べて、”いいねの数”を順番に並べ替えている。
      # 投稿に結びついているいいねを抽出して、並び替えしてる
    when 'old'
      @posts = @posts.order(created_at: :asc)
    else
      @posts = @posts.order(created_at: :desc)
    end

    @categories = Category.all
    @comments = Comment.all
  end

end