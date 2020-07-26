require "rails_helper"

RSpec.describe "User Orders Index Page Spec" do
  before :each do
    @user = create(:user)
    visit login_path
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_button 'Log In'

    @items1 = create_list(:item, 5)
    @items1.each do |item|
      visit "/items/#{item.id}"
      click_on "Add To Cart"
    end

    visit cart_path
    click_on "Checkout"
    fill_in :name, with: @user.name
    fill_in :address, with: @user.address
    fill_in :city, with: @user.city
    fill_in :state, with: @user.state
    fill_in :zip, with: @user.zip
    click_on "Create Order"
    expect(Order.all.count).to eq(1)

    @items2 = create_list(:item, 3)
    @items2.each do |item|
      visit "/items/#{item.id}"
      click_on "Add To Cart"
    end

    visit cart_path
    click_on "Checkout"
    fill_in :name, with: @user.name
    fill_in :address, with: @user.address
    fill_in :city, with: @user.city
    fill_in :state, with: @user.state
    fill_in :zip, with: @user.zip
    click_on "Create Order"
    expect(Order.all.count).to eq(2)

    @order1 = Order.all.first
    @order2 = Order.all.last

    @orders = [@order1, @order2]
  end

  describe "As a registered user with orders" do
    it "My profile has a link to my orders" do
      visit "/profile"
      expect(page).to have_link("View All Orders", href: "/profile/orders")
    end

    it "I see every order I've made on '/profile/orders'" do
      visit "/profile/orders"
      expect(page).to have_content("#{@user.name}'s Orders")
      expect(page).to have_css("section.order-#{@order1.id}")
      expect(page).to have_css("section.order-#{@order2.id}")
    end

    it "I see the details of each order" do
      visit "/profile/orders"
      @orders.each do |order|
        within("section.order-#{order.id}") do
          expect(page).to have_link("Order #{order.id}", href: "/orders/#{order.id}")
          expect(page).to have_content("Created at: #{order.created_at}")
          expect(page).to have_content("Updated at: #{order.updated_at}")
          expect(page).to have_content("Status: #{order.status}")
          expect(page).to have_content("Item Quantity: #{order.items.count}")
          expect(page).to have_content("Order Grand Total: #{order.grandtotal}")
        end
      end
    end
  end
end
