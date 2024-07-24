class CustomerProduct < ApplicationRecord
  belongs_to :product
  belongs_to :customer, class_name: 'User', foreign_key: :customer_id
end