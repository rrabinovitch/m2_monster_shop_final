require 'rails_helper'

RSpec.describe 'As an admin user, when I visit my admin dashboard' do
  before :each do
    @admin = create(:user, role: 2)
    @merchant1 = create(:merchant)
    @gizmos = create(:item, merchant: @merchant1, name: "Gizmos", price: 10, inventory: 10)

    @merchant2 = create(:merchant)
    @doodads = create(:item, merchant: @merchant2, name: "Doo Dads", price: 12, inventory: 5)

    @customer_1 = create(:user)
    @order_1 = create(:order, user: @customer_1, status: 0)
    @order_1.item_orders.create(item: @gizmos, price: @gizmos.price, quantity: 3, status: 0)
    @order_1.item_orders.create(item: @doodads, price: @doodads.price, quantity: 2, status: 1)

    @customer_2 = create(:user)
    @order_2 = create(:order, user: @customer_2, status: 2)
    @order_2.item_orders.create(item: @gizmos, price: @gizmos.price, quantity: 1, status: 1)

    @customer_3 = create(:user)
    @order_3 = create(:order, user: @customer_3, status: 3)
    @order_3.item_orders.create(item: @doodads, price: @doodads.price, quantity: 2, status: 0)

    @customer_4 = create(:user)
    @order_4 = create(:order, user: @customer_4, status: 1)
    @order_4.item_orders.create(item: @doodads, price: @doodads.price, quantity: 2, status: 0)

    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log In'

    visit "/admin"
  end

  it "I see all orders in the system. And for each order,
      I see the user who placed the order, the order id, and the date the order was created" do
    within("#order-#{@order_1.id}") do
      expect(page).to have_content("Order ##{@order_1.id}")
      expect(page).to have_content("Customer: #{@order_1.user.name}")
      expect(page).to have_content("Order placed on: #{@order_1.created_at}")
      # come back to edit view logic so that date doesn't present as the raw data - maybe an order class method?
    end
    expect(page).to have_css("#order-#{@order_2.id}")
    expect(page).to have_css("#order-#{@order_3.id}")
    expect(page).to have_css("#order-#{@order_4.id}")
  end

  it "For each order, the the info on the associated user links to the admin view of the user profile" do
    within("#order-#{@order_1.id}") do
      click_on "#{@order_1.user.name}"
    end
    expect(current_path).to eq("/admin/users/#{@order_1.user.id}")
  end

  it "The displayed orders are sorted by status: packaged > pending > shipped > cancelled)" do
    expect(page.all('h3')[0]).to have_content(@order_1.id)
    expect(page.all('h3')[1]).to have_content(@order_4.id)
    expect(page.all('h3')[2]).to have_content(@order_2.id)
    expect(page.all('h3')[3]).to have_content(@order_3.id)
  end

  it "I can click on a 'ship' button next to an order that is packaged, which changes that order's status to 'shipped'" do
    within("#order-#{@order_2.id}") do
      expect(page).to_not have_button("Ship")
    end
    within("#order-#{@order_1.id}") do
      click_button "Ship"
      expect(current_path).to eq("/admin")
      expect(page).to have_content("shipped")
    end
  end
  #
  # it "After a packaged order's 'ship' button is clicked, the customer can no longer 'cancel' the order." do
  #   within("#nav") do
  #     click_on 'Log Out'
  #   end
  #   visit login_path
  #   fill_in :email, with: @customer_1.email
  #   fill_in :password, with: @customer_1.password
  #   click_button 'Log In'
  #
  #   visit "/profile"
  # end
end


#patch method that connects the button to OrdersController#update action
  # @order = Order.find(params[:id])
  # @order.update(status: "packaged")
  # private params.permit(:status)
  # params will reference order id
