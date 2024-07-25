class CustomerProduct < ApplicationRecord
  belongs_to :product,optional: true
  belongs_to :customer, class_name: 'User', foreign_key: :customer_id
  validates :customer_id, presence: true 
end