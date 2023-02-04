class Public::PostsController < ApplicationController

  def index
    if params[:category_id]
      post_ids = PostCategory.where(category_id: params[:category_id]).pluck('post_id')
      # post_ids => [1,4]
      @posts = Post.where(id: post_ids)
      #該当するcategoryの投稿を抽出
    else
      @posts = Post.all
      #全ユーザーの投稿
    end

    #上で絞ったやつにsortかける。あれ？でもカテゴリーは並び変わらない…
    case params[:sort]
    when 'good'
      @posts = @posts.joins(:favorites).group(:post_id).order("count(post_id) desc")
    when 'old'
      @posts = @posts.order(created_at: :asc)
    else
      @posts = @posts.order(created_at: :desc)
    end

    @categories = Category.all#この位置は影響ある…？
    @comments = Comment.all
  end

  def new
    @post = Post.new
    @categories = Category.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      category_ids = params[:category_ids]
      category_ids.shift
      category_ids.each do |id|
        @post.post_categories.create!(category_id: id)
        #いいね機能と同じようなイメージ
        #ここで、PostモデルとPostcategoryモデル・categoryモデルを紐付けているイメージ
        #post_categoryモデルと作ることで、カテゴリー（タグ）が紐付く。カテゴリーidとPost idをpost_categoryに格納。
        #タグ付けも同じ方法で出来る。
      end
      redirect_to posts_path
    end
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
