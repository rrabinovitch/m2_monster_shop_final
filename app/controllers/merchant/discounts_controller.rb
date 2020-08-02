class Merchant::DiscountsController < ApplicationController
  before_action :require_authorized_user

  def index
    @discounts = Discount.where(merchant_id: current_user.merchant.id)
  end

  def new
    @discount = Discount.new
  end

  def create
    merchant = Merchant.find(current_user.merchant.id)
    merchant.discounts.create(discount_params)
    flash[:success] = "A new bulk discount has been created for #{merchant.name}"
    redirect_to merchant_discounts_path
  end

  private

  def unauthorized_user?
    current_user.nil? || current_user.regular? || current_user.admin?
  end

  def discount_params
    params.require(:discount).permit(:percentage, :minimum_item_quantity)
  end
end
