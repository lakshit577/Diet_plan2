class CreateOwnerProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :owner_products do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: { to_table: :users }, index: true
      t.integer :qty, null: false

      t.timestamps
    end
  end
end
