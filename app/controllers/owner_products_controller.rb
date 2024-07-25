class OwnerProductsController < ApplicationController
  def show   
    @owner_products = OwnerProduct.where(owner_id: current_user.id)
  end
end