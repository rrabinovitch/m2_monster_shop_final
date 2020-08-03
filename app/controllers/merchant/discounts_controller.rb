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
    discount = merchant.discounts.create(discount_params)
    if discount.save
      flash[:success] = "A new bulk discount has been created for #{merchant.name}"
      redirect_to merchant_discounts_path
    else
      flash[:error] = "All form fields must be filled in order to create a discount."
      redirect_to new_merchant_discount_path
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])
    discount.update(discount_params)
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
