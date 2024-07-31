class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    # debugger
    @users = User.where(role: :shop_owner)

    
  end

 
end
