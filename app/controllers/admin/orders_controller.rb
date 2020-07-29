class Admin::OrdersController < ApplicationController
  before_action :require_authorized_user

  def update
    @order = Order.find(params[:id])
    @order.update(status: "shipped")
    redirect_to '/admin'
  end

  private

  def unauthorized_user?
    current_user.nil? || current_user.regular? || current_user.merchant_employee?
  end
end
