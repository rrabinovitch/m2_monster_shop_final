class Merchant::ItemsController < ApplicationController
  before_action :require_authorized_user

  def index
    @merchant_employee = User.find(current_user.id)
  end

  def update
    @item = Item.find(params[:item_id])
  end

  def toggle_active
    @item = Item.find(params[:item_id])
    @item.toggle(:active?)
    @item.save
    if @item.active?
        flash[:success] = "#{@item.name} is now available for sale."
        redirect_to "/merchant/items"
    else
        flash[:success] = "#{@item.name} is no longer for sale."
        redirect_to "/merchant/items"
    end
  end

  private

  def unauthorized_user?
    current_user.nil? || current_user.regular? || current_user.admin?
  end
end
