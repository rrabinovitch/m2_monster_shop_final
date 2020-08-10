class Profile::OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
  end

  def update
    order = Order.find(params[:id])
    order.cancel
    order.save
    flash[:cancelled] = "The order is now cancelled"
    redirect_to "/profile"
  end

  def index
    @orders = current_user.orders
  end

end
