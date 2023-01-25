class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy

  #いいね機能
  has_many :favorites, dependent: :destroy

  #コメント機能
  has_many :comments, dependent: :destroy

end
