class Comment < ApplicationRecord

  #コメント機能
  belongs_to :user
  belongs_to :post

end
