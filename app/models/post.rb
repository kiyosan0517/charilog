class Post < ApplicationRecord
  has_many_attached :images
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user

  has_many :post_items, dependent: :destroy
  has_many :items, through: :post_items

  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags, dependent: :destroy

  has_many :comments, dependent: :destroy

  has_one :route, dependent: :destroy

  validates :title, presence: true
end
