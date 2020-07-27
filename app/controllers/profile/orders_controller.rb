class Profile::OrdersController < ApplicationController

  def show
    @order = Order.find(params[:order_id])
  end

  def update
    order = Order.find(params[:order_id])
    order.cancel
    order.save
    flash[:cancelled] = "The order is now cancelled"
    redirect_to "/profile"
  end

end
