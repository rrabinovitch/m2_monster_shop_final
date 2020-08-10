class Merchant::ItemsController < ApplicationController
  before_action :require_authorized_user

  def index
    @merchant_employee = User.find(current_user.id)
  end

  def new
    @item = Item.new(session.delete(:item_params))
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    merchant = Merchant.find(current_user.merchant.id)
    @item = merchant.items.create(item_params)
    if @item.save
      flash[:success] = "Added #{@item.name} to item list"
      redirect_to "/merchant/items"
    else
      flash[:failure] = "All fields must be completed before submitting:"
      flash[:error] = @item.errors.full_messages.to_sentence
      session[:params] = item_params
      render :new
    end
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    if @item.save
      flash[:success] = "Item has been updated"
      redirect_to "/merchant/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
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

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    flash[:success] = "#{item.name} has been deleted."
    redirect_to "/merchant/items"
  end

  private

  def unauthorized_user?
    current_user.nil? || current_user.regular? || current_user.admin?
  end

  def item_params
    if params[:image].empty?
      params[:image] = "https://www.webfx.com/blog/images/cdn.designinstruct.com/files/582-how-to-image-placeholders/generic-image-placeholder.png"
    end
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
