class OwnerProductsController < ApplicationController
  def index
    @owner_products = OwnerProduct.all  
  end
end