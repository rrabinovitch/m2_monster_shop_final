require "rails_helper"

RSpec.describe "Checking Out Registered Users Spec" do
  before :each do
    @item = create(:item)
    @user = create(:user)

    visit login_path
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button 'Log In'

    visit "/items/#{@item.id}"
    click_on "Add To Cart"

    visit cart_path
    expect(Order.all.count).to eq(0)

    click_on "Checkout"
    expect(current_path).to eq("/orders/new")

    fill_in :name, with: @user.name
    fill_in :address, with: @user.address
    fill_in :city, with: @user.city
    fill_in :state, with: @user.state
    fill_in :zip, with: @user.zip

    click_on "Create Order"

    expect(Order.all.count).to eq(1)

    @order = Order.all.first
  end

  describe "When I check out as a logged in user" do
    it "An order is created in the system with status 'pending'" do
      expect(@order.status).to eq("pending")
    end

    it "That order is associated with my user" do
      expect(@user.orders).to include(@order)
    end

    it "I am taken to my updated profile orders page" do
      expect(current_path).to eq("/profile/orders")
      expect(page).to have_content("Your order was created")
      within("section.order-#{@order.id}") do
        expect(page).to have_content(@order.grandtotal)
      end
    end

    it "My cart is now empty" do
      within "nav" do
        expect(page).to have_content("Cart: 0")
      end
    end
  end
end
