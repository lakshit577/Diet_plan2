class ShopOwner
  attr_accessor :name, :products, :customers

  def initialize(name)
    @name = name
    @products = []
    @customers = []
  end

  def add_product(name)
    @products << { name: name }
  end

  def add_customer(customer)
    @customers << customer
  end

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

    # Print the weekly plan
    puts "Weekly plan:"
    (0..6).each do |day|
      daily_products = weekly_plan.select { |day_plan| day_plan[:day] == day }
      puts "Day #{day}: #{daily_products.map { |plan| plan[:product] }.join(', ')}"
    end

    # Print each customer's bucket
    @customers.each do |customer|
      customer_bucket = customer.diet_plans.map { |dp| dp[:product] }
      puts "Bucket for #{customer.name}: #{customer_bucket}"
    end

    weekly_plan
  end
end

# Define a class for Customer
class Customer
  attr_accessor :name, :diet_plans

  def initialize(name)
    @name = name
    @diet_plans = []
  end

  def choose_products(products)
    products_to_choose = products.dup

    3.times do
      product = products_to_choose.sample
      products_to_choose.delete(product)
      quantity = rand(1..10) # random quantity between 1 and 10
      @diet_plans << { product: product[:name], quantity: quantity }
    end
  end
end

# Create some dummy data
shop_owner = ShopOwner.new('John Doe')
shop_owner.add_product('Apple')
shop_owner.add_product('Carrot')
shop_owner.add_product('Banana')
shop_owner.add_product('Broccoli')
shop_owner.add_product('Orange')
shop_owner.add_product('Spinach')
shop_owner.add_product('Grapes')
shop_owner.add_product('Pear')
shop_owner.add_product('Peas')

customer1 = Customer.new('Jane Doe')
customer1.choose_products(shop_owner.products)
shop_owner.add_customer(customer1)

customer2 = Customer.new('John Smith')
customer2.choose_products(shop_owner.products)
shop_owner.add_customer(customer2)

customer3 = Customer.new('Alice Johnson')
customer3.choose_products(shop_owner.products)
shop_owner.add_customer(customer3)

customer4 = Customer.new('Bob Brown')
customer4.choose_products(shop_owner.products)
shop_owner.add_customer(customer4)

customer5 = Customer.new('Charlie Davis')
customer5.choose_products(shop_owner.products)
shop_owner.add_customer(customer5)

# Generate the weekly plan
weekly_plan = shop_owner.generate_weekly_plan
