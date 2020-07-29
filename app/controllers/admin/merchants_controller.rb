class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    merchant.change_status
    merchant.change_active_status
    if merchant.enabled?
      flash[:enabled] = "You have now enabled #{merchant.name}"
    else
      flash[:disabled] = "You have now disabled #{merchant.name}"
    end
    redirect_to "/admin/merchants"
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end
end
