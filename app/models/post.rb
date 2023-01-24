class Post < ApplicationRecord
  has_one_attached :image

  #post_category(中間テーブル)作成後、編集
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories

  belongs_to :user
end
