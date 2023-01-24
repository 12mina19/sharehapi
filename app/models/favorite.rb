class Favorite < ApplicationRecord

  #いいね機能
  belongs_to :user
  belongs_to :post

end
