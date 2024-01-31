class Post < ApplicationRecord
  has_many_attached :images
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user

  validates :title, presence: true
end
