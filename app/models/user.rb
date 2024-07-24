class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { shop_owner: 0, customer: 1 }

  has_many :customer_products, foreign_key: :customer_id
  has_many :owner_products, foreign_key: :owner_id
  has_many :owned_products, through: :owner_products, source: :product
  has_many :purchased_products, through: :customer_products, source: :product
end
