class OrdersController <ApplicationController

  def new
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = Order.new(order_params)
    if order_params.values.none?(&:empty?) && logged_in_user
      logged_in_user.orders << order
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
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def index
    @orders = logged_in_user.orders
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
