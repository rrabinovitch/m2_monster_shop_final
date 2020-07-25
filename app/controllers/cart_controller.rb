class CartController < ApplicationController
  before_action :require_authorized_user

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def add_single_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    redirect_to "/cart"
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def remove_single_item
    item = Item.find(params[:item_id])
    cart.remove_item(item.id.to_s)
    redirect_to '/cart'
  end

  private

  def unauthorized_user?
    (current_user && current_user.admin?)
  end
end
