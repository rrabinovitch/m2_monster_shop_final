class CartController < ApplicationController
  before_action :require_authorized_user

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    if request.original_url.include?(cart_path)
      redirect_to "/cart"
    else
      redirect_to "/items"
    end
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

  private

  def unauthorized_user?
    (logged_in_user && logged_in_user.admin?)
  end
end
