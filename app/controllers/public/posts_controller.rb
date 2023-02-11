class Public::PostsController < ApplicationController

  def index
    if params[:category_id]
      post_ids = PostCategory.where(category_id: params[:category_id]).pluck('post_id').page(params[:page])
      # post_ids => [1,4]
      @category = params[:category_id]
      @posts = Post.where(id: post_ids)
      #該当するcategoryの投稿を抽出
    else
      @posts = Post.all
      #全ユーザーの投稿
    end

    #上で絞ったやつにsortかける
    case params[:sort]
    when 'good'
      @posts = @posts.includes(:favorites).sort {|a,b| b.favorites.size <=> a.favorites.size}.page(params[:page])
      # @posts = @posts.left_joins(:favorites).group(:post_id).order("count(post_id) desc")
      # 投稿に結びついているいいねを抽出して、並び替えしてる
      # group：指定したカラムのレコードの種類ごとにデータをまとめるメソッド
      # 内部結合(join)：AとBのテーブル両方に同じIDがあったら、抽出される
      # 外部結合(left_joins)：基準となるテーブルに存在すれば、両方のテーブルになくても抽出される
      # 最初joinしか記載していなかった為、いいね順で「いいね0」の時、表示されていなかった。
      # そこで、left_joinsに記載を変更したところ、「いいね0」の時でも表示された。
      ###############################
      # でも後日テストでエラー出た。これだと、いいねが０個の時に正しく表示されない（表示されない”いいね０”があった）上記に書き換え
      #この式の意味は、a.b.cをPostの中のfavoritesに見立てて、each文で回していく中で”いいねの数”をa.b.cで順番に比べて、”いいねの数”を順番に並べ替えている。
    when 'old'
      @posts = @posts.order(created_at: :asc).page(params[:page])
    else
      @posts = @posts.order(created_at: :desc).page(params[:page])
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
