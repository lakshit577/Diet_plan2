class CreateCreateWeekPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :create_week_plans do |t|
      t.integer :day
      t.integer :customer_id
      t.integer :product_id

      t.timestamps
    end
  end
end
