class Post < ApplicationRecord
  has_many_attached :images
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user

  has_many :post_items, dependent: :destroy
  has_many :items, through: :post_items

  has_many :comments, dependent: :destroy

  validates :title, presence: true
end
