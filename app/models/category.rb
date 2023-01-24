class Category < ApplicationRecord

  #Categoryモデル(1)とpostモデル(N)の関連付け
  has_many :posts, dependent: :destroy

end
