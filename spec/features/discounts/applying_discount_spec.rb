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

  it "When an item in my cart meets the minimum quantity required for a discount, the discounted total appearas on my cart page." do
    cart = Cart.new({"#{@item_1.id}" => 5})
    allow_any_instance_of(ApplicationController).to receive(:cart).and_return(cart)
    visit cart_path
    expect(page).to have_content("Total: $500")
    expect(page).to have_content("Total with discount: $375")
    # should the items in the cart display the discounted amount individually?
  end

  it "When I have multiple items in my cart from the same shop, but only one meets the minimum quantity required for a discount,
      only the item with that required quantity is discounted." do
    cart = Cart.new({"#{@item_1.id}" => 5, "#{@item_2.id}" => 2})
    allow_any_instance_of(ApplicationController).to receive(:cart).and_return(cart)
    visit cart_path
    expect(page).to have_content("Total: $700")
    expect(page).to have_content("Total with discount: $575")
  end

  it "My cart is not discounted if I have several items adding up to the minimum quantity for a discount (discount is only applied when a single item meets the minimum quantity requirement)." do
    cart = Cart.new({"#{@item_1.id}" => 1, "#{@item_2.id}" => 1, "#{@item_3.id}" => 1, "#{@item_4.id}" => 1, "#{@item_5.id}" => 1})
    allow_any_instance_of(ApplicationController).to receive(:cart).and_return(cart)
    visit cart_path
    expect(page).to have_content("Total: $500")
    expect(page).to_not have_content("Total with discount")
  end
end
