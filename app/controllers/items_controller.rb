class ItemsController<ApplicationController

  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.active_items
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    item = @merchant.items.create(item_params)
    if item.save
      redirect_to "/merchants/#{@merchant.id}/items"
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    if @item.save
      redirect_to "/items/#{@item.id}"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    redirect_to "/items"
  end

  private

  def item_params
    if params[:image].empty?
      params[:image] = "https://www.webfx.com/blog/images/cdn.designinstruct.com/files/582-how-to-image-placeholders/generic-image-placeholder.png"
    end
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
