require "rails_helper"

RSpec.describe "Order Status Update Spec" do
  before :each do
    @items = create_list(:item, 2)
    @item1, @item2 = @items

    @order1 = create(:order)
    @order1.item_orders.create!(item: @item1, price: @item1.price, quantity: 1)
    @order1.item_orders.create!(item: @item2, price: @item2.price, quantity: 1)
    @order1 = Order.all.first
  end

  describe "As a registered user" do
    describe "My Order Status can change" do
      it "It is 'pending' if all items in the order are still unfulfilled" do
        expect(@order1.item_orders.all?(&:unfulfilled?)).to be_truthy

        visit "/profile/orders/#{@order1.id}"

        expect(page).to have_content("Status: pending")
      end
      it "It is 'pending' if any items in the order are still unfulfilled" do
        @order1.item_orders.first.fulfill

        expect(@order1.item_orders.any?(&:unfulfilled?)).to be_truthy
        expect(@order1.item_orders.any?(&:fulfilled?)).to be_truthy

        visit "/profile/orders/#{@order1.id}"

        expect(page).to have_content("Status: pending")
      end
      it "It is 'packaged' if all items in the order become fulfilled" do
        @order1.item_orders.each(&:fulfill)
        expect(@order1.item_orders.all?(&:fulfilled?)).to be_truthy

        visit "/profile/orders/#{@order1.id}"
        expect(page).to have_content("Status: packaged")
      end
    end
  end
end
