class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    merchant.change_status
    flash[:disabled] = "You have now disabled #{merchant.name}"
    redirect_to "/admin/merchants"
  end

end
