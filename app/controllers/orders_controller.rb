class OrdersController <ApplicationController

  def new
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = Order.new(order_params)
    can_create_order? ? create_new(order) : retry_order_creation
  end

  def index
    @orders = current_user.orders
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

  def can_create_order?
    order_params.values.none?(&:empty?) && current_user
  end

  def create_new(order)
    current_user.orders << order
    cart.items.each do |item,quantity|
      order.item_orders.create({
        item: item,
        quantity: quantity,
        price: item.price
        })
    end
    session.delete(:cart)
    flash[:success] = "Your order was created"
    redirect_to "/profile/orders"
  end

  def retry_order_creation
    flash[:notice] = "Please complete address form to create an order."
    render :new
  end
end
