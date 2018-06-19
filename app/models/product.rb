class Product < ApplicationRecord
  # image uploader
  mount_uploader :image, ImageUploader
  # associations
  belongs_to :category
  has_many :line_items
end
