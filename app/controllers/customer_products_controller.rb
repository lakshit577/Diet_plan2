class CustomerProductsController < ApplicationController
  def new
    @owner_products = OwnerProduct.where(owner_id: params[:format].to_i)
  end

  def create

   if CustomerProduct.all.where(customer_id: current_user.id ) !=[]
    flash[:notice] = "already_present."
    redirect_to home_index_path
    return
   end

    selected_ids = params[:owner_product_ids] || []
    quantity = params[:quantity].to_i

    if selected_ids == []
      CustomerProduct.create!(
          product_id: nil,
          customer_id:current_user.id,
          qty: 5
        )
    end
    if selected_ids.size > 3
      flash.now[:error] = "You can only select up to 3 products."
      @owner_products = OwnerProduct.where(owner_id: params[:id].to_i)
      render :new, status: :unprocessable_entity
      return
    end
    selected_ids.each do |id|
      owner_product = OwnerProduct.find_by(id: id)
      if quantity >= 0
        CustomerProduct.create!(
          product_id: id,
          customer_id:current_user.id,
          qty: quantity
        )
      end
    end
    flash[:notice] = "Products successfully added."
    redirect_to home_index_path # Change to the desired path after creation
  end
  def show
    @customer_products = CustomerProduct.where(customer_id: current_user.id)
  end
end
