# class OwnerProductsController < ApplicationController
#   def show   
#     @owner_products = OwnerProduct.where(owner_id: current_user.id)
#     # debugger
#     days_in_week = Date::DAYNAMES.size
#     # current_day = Date.today.strftime("%A")
#     current_day = "Sunday"
#     distinct_product_ids = CustomerProduct.where.not(product_id: nil).pluck(:product_id).uniq.count
#     product_qty_hash = CustomerProduct.where.not(product_id: nil).group(:product_id).sum(:qty)
#     product_id_count_hash = CustomerProduct.where.not(product_id: nil).group(:product_id).count.sort_by { |product_id, count| -count }.to_h 
#     values_array = product_id_count_hash.values
#     keys_array = product_id_count_hash.keys
#     if CustomerProduct.all != []
#     days_in_week.times do
     
#       if current_day == "Monday"
#         product_id = keys_array.first
#         remaining_users = User.where(role: "customer").count - values_array.first
#         qty = product_qty_hash[product_id]
#         if OwnerProduct.exists?(product_id: product_id)
#           OwnerProduct.where.not(product_id: product_id).update_all(qty: 0)
#           OwnerProduct.where(product_id: product_id).update(qty: qty + 5 * remaining_users)
#         end
#       end
      
#       if current_day == "Tuesday"
#         product_id = keys_array[1]  # Note: index 1 for second element
#         remaining_users = User.where(role: "customer").count - values_array[1]
#         qty = product_qty_hash[product_id]
#         if OwnerProduct.exists?(product_id: product_id)
#           OwnerProduct.where.not(product_id: product_id).update_all(qty: 0)
#           OwnerProduct.where(product_id: product_id).update(qty: qty + 5 * remaining_users)
#         end
#       end
      
#       if current_day == "Wednesday"
#         product_id = keys_array[2]  # Note: index 2 for third element
#         remaining_users = User.where(role: "customer").count - values_array[2]
#         qty = product_qty_hash[product_id]
#         if OwnerProduct.exists?(product_id: product_id)
#           OwnerProduct.where.not(product_id: product_id).update_all(qty: 0)
#           OwnerProduct.where(product_id: product_id).update(qty: qty + 5 * remaining_users)
#         end
#       end
      
#       if current_day == "Thursday"
#         product_id = keys_array[3]  # Note: index 3 for fourth element
#         remaining_users = User.where(role: "customer").count - values_array[3]
#         qty = product_qty_hash[product_id]
#         if OwnerProduct.exists?(product_id: product_id)
#           OwnerProduct.where.not(product_id: product_id).update_all(qty: 0)
#           OwnerProduct.where(product_id: product_id).update(qty: qty + 5 * remaining_users)
#         end
#       end
      
#       if current_day == "Friday"
#         product_id = keys_array[4]  # Note: index 4 for fifth element
#         remaining_users = User.where(role: "customer").count - values_array[4]
#         qty = product_qty_hash[product_id]
#         if OwnerProduct.exists?(product_id: product_id)
#           OwnerProduct.where.not(product_id: product_id).update_all(qty: 0)
#           OwnerProduct.where(product_id: product_id).update(qty: qty + 5 * remaining_users)
#         end
#       end
      
#       if current_day == "Saturday"
#         product_id = keys_array[5]  # Note: index 5 for sixth element
#         remaining_users = User.where(role: "customer").count - values_array[5]
#         qty = product_qty_hash[product_id]
#         if OwnerProduct.exists?(product_id: product_id)
#           OwnerProduct.where.not(product_id: product_id).update_all(qty: 0)
#           OwnerProduct.where(product_id: product_id).update(qty: qty + 5 * remaining_users)
#         end
#       end
#       if product_id_count_hash.count > 7  


#       if current_day == "Sunday"
#         debugger
#         User.where(role: "customer").count
#         product_id = keys_array[6] 
#         qty = product_qty_hash[product_id]
#         if OwnerProduct.exists?(product_id: product_id)
#           OwnerProduct.where.not(product_id: product_id).update_all(qty: 0)
#           OwnerProduct.where(product_id: product_id).update(qty: qty)
#         end

#         product_id = keys_array[7]  
#         remaining_users = User.where(role: "customer").count - values_array[7]
#         qty = product_qty_hash[product_id]
#         if OwnerProduct.exists?(product_id: product_id)
#           OwnerProduct.where(product_id: product_id).update(qty: qty + 5 * (remaining_users - 1))
#         end
#       end
#     end
#     end
#   end
#   end
# end

class OwnerProductsController < ApplicationController
  def show
    @owner_products = OwnerProduct.where(owner_id: current_user.id)
    @products = Product.all.map { |p| { id: p.id, name: p.name } }
    @customers = User.where(role: "customer")

    # Generate weekly plan
    weekly_plan = generate_weekly_plan

    # Output the weekly plan for debugging purposes
    puts "Weekly plan:"
    (0..6).each do |day|
      daily_products = weekly_plan.select { |day_plan| day_plan[:day] == day }
      puts "Day #{Date::DAYNAMES[day]}: #{daily_products.map { |plan| plan[:product] }.join(', ')}"
    end
  end

  private

  def generate_weekly_plan
    # Create a copy of products to avoid modifying the original array
    products_copy = @products.dup

    # Create a weekly plan
    weekly_plan = []
    days_with_extra_products = []

    # Randomly assign products to each day
    7.times do |day|
      if products_copy.empty?
        break
      end

      product = products_copy.sample
      weekly_plan << { day: day, product: product[:name] }
      products_copy.delete(product)
    end

    # If there are more products than days, add remaining products
    days_with_extra_products = products_copy.map { |product| product[:name] }

    # Add remaining products to the plan, with some days getting multiple products
    days_with_extra_products.each_with_index do |product, index|
      day = index % 7
      weekly_plan << { day: day, product: product }
    end

    # Ensure each customer's bucket products are available in the weekly plan
    @customers.each do |customer|
      customer_bucket = customer.diet_plans.map { |dp| dp[:product] }
      customer_bucket.each do |product|
        unless weekly_plan.any? { |day_plan| day_plan[:product] == product }
          # Ensure no duplicates in the weekly plan
          weekly_plan << { day: weekly_plan.size % 7, product: product }
        end
      end
    end

    # Update OwnerProduct quantities based on the weekly plan
    update_owner_products(weekly_plan)

    weekly_plan
  end

  def update_owner_products(weekly_plan)
    product_count = weekly_plan.group_by { |day_plan| day_plan[:product] }.transform_values(&:count)

    product_count.each do |product_name, count|
      product_id = Product.find_by(name: product_name).id
      remaining_users = @customers.count

      if OwnerProduct.exists?(product_id: product_id)
        OwnerProduct.where.not(product_id: product_id).update_all(qty: 0)
        OwnerProduct.where(product_id: product_id).update(qty: count + 5 * remaining_users)
      else
        OwnerProduct.create(product_id: product_id, qty: count + 5 * remaining_users)
      end
    end
  end
end
