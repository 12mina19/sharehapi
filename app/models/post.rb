class Post < ApplicationRecord
  has_one_attached :image

  #Categoryモデル(1)とpostモデル(N)の関連付け
  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories

end
