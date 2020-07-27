class Profile::OrdersController < ApplicationController

  def show
    @order = Order.find(params[:order_id])
  end
end
