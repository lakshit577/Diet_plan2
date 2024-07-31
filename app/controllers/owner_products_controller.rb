class OwnerProductsController < ApplicationController
  def index   
    @days = %w[monday tuesday wednesday thursday friday saturday sunday]
    
    # Group week plans by day and ensure the order
    @week_plans_by_day = CreateWeekPlan.all.group_by(&:day)
    @week_plans_by_day = @days.each_with_object({}) do |day, hash|
      hash[day] = @week_plans_by_day[day] || []
    end

    # Fetch all distinct customer IDs
    @customers = CreateWeekPlan.distinct.pluck(:customer_id)
  end
  def show   
    @owner_products = OwnerProduct.all
    # @current_day = Date.today.strftime('%A')
    @current_day ="Tuesday"


  @results = CreateWeekPlan
  .joins("INNER JOIN customer_products ON customer_products.product_id = create_week_plans.product_id")
  .group("create_week_plans.day, create_week_plans.product_id")
  .select("create_week_plans.day, create_week_plans.product_id, SUM(customer_products.qty) AS total_qty")
  end

  
  def genrate_plan 

    distinct_product_ids = CustomerProduct.where.not(product_id: nil).distinct.pluck(:product_id)

    max_customer_id = CustomerProduct.group(:customer_id) .order('COUNT(product_id) DESC') .count .first .tap { |cust_id, count| User.find(cust_id) }.first  
    owner_product_ids = OwnerProduct.distinct.pluck(:product_id)
    products_ids = CustomerProduct.pluck(:product_id)   
    if products_ids.count < 7 
      final_ids = products_ids.uniq
      additional_ids = (owner_product_ids - final_ids).first(8 - final_ids.size)
      final_ids.concat(additional_ids).uniq!
      final_ids = final_ids.take(7)
      products_ids = final_ids
    else
      products_ids = CustomerProduct.where(customer_id: max_customer_id).pluck(:product_id) 
      products_ids.sort!
      7.times do |i|
        if(products_ids.include?(distinct_product_ids[i]))
           
        else
          products_ids.push(distinct_product_ids[i])
        end
      end
    end
    customer_ids = CustomerProduct.distinct.pluck(:customer_id)
    customer_ids.each do |customer|
      customer_product_ids = CustomerProduct.where(customer_id: customer).pluck(:product_id)
      customer_product_ids.sort!
      if(customer_product_ids.first.nil?)
        i = 0
        (products_ids ).each do |id|
          week_plan = CreateWeekPlan.find_or_create_by(day: i, product_id: id, customer_id: customer)

          i= i+1
        end
      else
        i = 0
        product_id_not =(customer_product_ids - products_ids)
        product_id_not.each do |id|
          CreateWeekPlan.find_or_create_by(day: i, product_id: id, customer_id: customer)
          i= i+1
        end
        a = Marshal.load(Marshal.dump(products_ids))
        product_id_not.each do |p|
          a.shift()
        end
        (a).each do |id|
          if i == 7 
            next
          end
          CreateWeekPlan.find_or_create_by(day: i, product_id: id, customer_id: customer)
          i= i+1
        end
      end
    end
    redirect_to owner_products_path() , notice: "genrate scucssfully "
  end
end