class RenameUserIdToOwnerIdInOwnerProducts < ActiveRecord::Migration[6.1]
  def change
    rename_column :owner_products, :user_id, :owner_id
  end
end