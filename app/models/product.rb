class Product < ApplicationRecord
  has_many :customer_products
  has_many :owner_products
  has_many :owners, through: :owner_products, source: :user
end