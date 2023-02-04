class Post < ApplicationRecord
  has_one_attached :image

  #post_category作成後、編集(複数選択出来るように中間テーブルを作成)
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories
  #※中間テーブルがあるときはt、Postがhrough:：(中間テーブル)を通して、categoryの情報を取りに行くイメージ
  #その際は、カテゴリーが紐付いた投稿は消さないように、dependentは記述しない。
  #このやり方で、カテゴリーは消えるが、それに紐付いた投稿は残るようになる。


  belongs_to :user

  #コメント機能
  has_many :comments, dependent: :destroy

  #いいね機能
  has_many :favorites, dependent: :destroy

  #この(user)にfavoritedされているかを確認するメソッド
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

end
