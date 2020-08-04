require 'rails_helper'

RSpec.describe "As a regular user" do
  before :each do
    @user = create(:user)
    @merchant = create(:merchant)
    @item_1 = create(:item, merchant: @merchant)
    @item_2 = create(:item, merchant: @merchant)
    @item_3 = create(:item, merchant: @merchant)
    @item_4 = create(:item, merchant: @merchant)
    @item_5 = create(:item, merchant: @merchant)
    @discount = @merchant.discounts.create(percentage: 25, minimum_item_quantity: 5)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it "When an item in my cart meets the minimum quantity required for a discount, the discounted subtotal for that item order appears on my cart page." do
    cart = Cart.new({"#{@item_1.id}" => 5})
    allow_any_instance_of(ApplicationController).to receive(:cart).and_return(cart)
    visit cart_path
    within("#cart-item-#{@item_1.id}") do
      expect(page).to have_content("$375")
    end
    expect(page).to have_content("Total: $375")
  end

  it "When I have multiple items in my cart from the same shop, but only one meets the minimum quantity required for a discount,
      only the item with that required quantity is discounted." do
    cart = Cart.new({"#{@item_1.id}" => 5, "#{@item_2.id}" => 2})
    allow_any_instance_of(ApplicationController).to receive(:cart).and_return(cart)
    visit cart_path
    within("#cart-item-#{@item_1.id}") do
      expect(page).to have_content("$375")
    end
    within("#cart-item-#{@item_2.id}") do
      expect(page).to have_content("$200")
    end
    expect(page).to have_content("Total: $575")
  end

  it "My cart is not discounted if I have several items adding up to the minimum quantity for a discount (discount is only applied when a single item meets the minimum quantity requirement)." do
    cart = Cart.new({"#{@item_1.id}" => 1, "#{@item_2.id}" => 1, "#{@item_3.id}" => 1, "#{@item_4.id}" => 1, "#{@item_5.id}" => 1})
    allow_any_instance_of(ApplicationController).to receive(:cart).and_return(cart)
    visit cart_path
    within("#cart-item-#{@item_1.id}") do
      expect(page).to have_content("$100")
    end
    within("#cart-item-#{@item_2.id}") do
      expect(page).to have_content("$100")
    end
    within("#cart-item-#{@item_3.id}") do
      expect(page).to have_content("$100")
    end
    within("#cart-item-#{@item_4.id}") do
      expect(page).to have_content("$100")
    end
    within("#cart-item-#{@item_5.id}") do
      expect(page).to have_content("$100")
    end
    expect(page).to have_content("Total: $500")
  end

  it "After I've placed an order to which a discount has been applied, the discount is reflected on that order show page." do
    cart = Cart.new({"#{@item_1.id}" => 5})
    allow_any_instance_of(ApplicationController).to receive(:cart).and_return(cart)
    visit orders_new_path
    fill_in :name, with: @user.name
    fill_in :address, with: @user.address
    fill_in :city, with: @user.city
    fill_in :state, with: @user.state
    fill_in :zip, with: @user.zip
    click_on "Create Order"
    order = Order.last
    visit "/profile/orders/#{order.id}"
    within("#item-#{@item_1.id}") do
      expect(page).to have_content("$375")
    end
    expect(page).to have_content("Grand Total: $375")
  end
end
