class Item < ApplicationRecord
  has_many :post_items, dependent: :destroy
  has_many :posts, through: :post_items
end
