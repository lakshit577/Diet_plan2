class CustomerDietPlansController < ApplicationController
  def new
    @customer_diet_plan = CustomerDietPlan.new
  end
  
  def create
    debugger
    @customer_diet_plan = CustomerDietPlan.new
    CreateWeekPlan.where(customer_id: current_user)
    
  end
end
