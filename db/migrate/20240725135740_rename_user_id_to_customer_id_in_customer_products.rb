class RenameUserIdToCustomerIdInCustomerProducts < ActiveRecord::Migration[7.1]
  def change
    rename_column :customer_products, :user_id, :customer_id
  end
end
