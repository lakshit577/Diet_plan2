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





# class OwnerProductsController < ApplicationController
#   def show   
#     @owner_products = OwnerProduct.where(owner_id: current_user.id)

#     current_day = "Monday" 
#     user_count = User.where(role: "customer").count

#     product_qty_hash = CustomerProduct.where.not(product_id: nil).group(:product_id).sum(:qty)
#     product_id_count_hash = CustomerProduct.where.not(product_id: nil).group(:product_id).count
#     product_id_count_hash = product_id_count_hash.sort_by { |_, count| -count }.to_h 

#     return unless product_id_count_hash.present?

#     # Extract keys and values
#     keys_array = product_id_count_hash.keys
#     values_array = product_id_count_hash.values

#     # Initialize a hash to track product updates
#     product_updates = Hash.new { |hash, key| hash[key] = 0 }

#     # Update quantities based on the current day
#     case current_day
#     when "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
#       day_index = Date::DAYNAMES.index(current_day)
#       product_id = keys_array[day_index]
#       if product_id
#         remaining_users = user_count - values_array[day_index]
#         qty = product_qty_hash[product_id]
#         product_updates[product_id] = qty + 5 * remaining_users
#       end

#     when "Sunday"
#       # Handle Sunday separately for additional products
#       keys_array.each_with_index do |product_id, index|
#         next unless product_id # Safeguard against nil values
        
#         remaining_users = user_count - values_array[index]
#         qty = product_qty_hash[product_id]
        
#         if index < 7
#           # Update the first 6 products as previously handled
#           product_updates[product_id] = 0
#         else
#           # Handle additional products
#           product_updates[product_id] = qty + 5 * (remaining_users )
#         end
#       end
#     end

#     # Update the database with the new quantities
#     if product_updates.any?
#       OwnerProduct.where(owner_id: current_user.id).update_all(qty: 0) # Reset all quantities first
#       product_updates.each do |product_id, qty|
#         if OwnerProduct.exists?(product_id: product_id)
#           OwnerProduct.where(product_id: product_id).update(qty: qty)
#         else
#           OwnerProduct.create(owner_id: current_user.id, product_id: product_id, qty: qty)
#         end
#       end
#     end
#   end
# end



class OwnerProductsController < ApplicationController
  def show   
    @owner_products = OwnerProduct.where(owner_id: current_user.id)

    current_day = "Tuesday" 
    user_count = User.where(role: "customer").count

    product_qty_hash = CustomerProduct.where.not(product_id: nil).group(:product_id).sum(:qty)
    product_id_count_hash = CustomerProduct.where.not(product_id: nil).group(:product_id).count
    product_id_count_hash = product_id_count_hash.sort_by { |_, count| -count }.to_h 

    return unless product_id_count_hash.present?

    # Extract keys and values
    keys_array = product_id_count_hash.keys
    values_array = product_id_count_hash.values

    # Initialize a hash to track product updates
    product_updates = Hash.new { |hash, key| hash[key] = 0 }

    # Determine the number of products to update for each day
    num_products_per_day = 2 # Number of products to be assigned per day (example: 2)
    start_index = Date::DAYNAMES.index(current_day) * num_products_per_day

    # Update quantities based on the current day
    case current_day
    when "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
      products_today = keys_array[start_index, num_products_per_day] # Get the products for the day
      products_today.each_with_index do |product_id, index|
        next unless product_id # Safeguard against nil values

        remaining_users = user_count - values_array[start_index + index]
        qty = product_qty_hash[product_id]
        product_updates[product_id] = qty + 5 * remaining_users
      end

    when "Sunday"
      # Handle Sunday for all remaining products
      keys_array.each_with_index do |product_id, index|
        next unless product_id # Safeguard against nil values
        
        remaining_users = user_count - values_array[index]
        qty = product_qty_hash[product_id]
        
        if index < 7
          # Update the first 7 products as previously handled
          product_updates[product_id] = 0
        else
          # Handle additional products
          product_updates[product_id] = qty + 5 * remaining_users
        end
      end
    end

    # Update the database with the new quantities
    if product_updates.any?
      OwnerProduct.where(owner_id: current_user.id).update_all(qty: 0) # Reset all quantities first
      product_updates.each do |product_id, qty|
        if OwnerProduct.exists?(product_id: product_id)
          OwnerProduct.where(product_id: product_id).update(qty: qty)
        else
          OwnerProduct.create(owner_id: current_user.id, product_id: product_id, qty: qty)
        end
      end
    end
  end
end
