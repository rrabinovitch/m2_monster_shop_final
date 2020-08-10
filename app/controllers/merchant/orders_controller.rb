class Merchant::OrdersController < ApplicationController
  before_action :require_authorized_user
  helper_method :current_merchant

  def show
    @order = Order.find(params[:id])
  end

  private

  def unauthorized_user?
    current_user.nil? || current_user.regular? || current_user.admin?
  end

  def current_merchant
    @merchant ||= Merchant.find(current_user.merchant_id)
  end
end
