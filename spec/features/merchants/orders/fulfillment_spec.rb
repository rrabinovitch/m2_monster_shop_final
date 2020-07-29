require "rails_helper"

RSpec.describe "Merchant Order Fulfillment Spec" do
  before :each do
    @merchant1 = create(:merchant)
    @item1 = create(:item, merchant: @merchant1, inventory: 1)
    @item2 = create(:item, merchant: @merchant1, inventory: 2)

    @order = create(:order)
    @enough_inventory = @order.item_orders.create!(item: @item1, price: @item1.price, quantity: 1)
    @lacking_inventory = @order.item_orders.create!(item: @item2, price: @item2.price, quantity: 3)

    @merchant_employee = create(:user, role: 1, merchant: @merchant1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    visit "/merchant/orders/#{@order.id}"
  end

  describe "As a merchant employee: When I visit an order show page from my dashboard" do
    describe "For each item of mine in the order" do

      describe "I can fulfill part of an order if I have enough inventory" do
        it "Clicking the Fulfill Items button changes the status of the item in the order" do
          within ("section#item-#{@enough_inventory.item_id}") do
            expect(page).to_not have_content("- FULFILLED")

            click_button "Fulfill Items"
          end

          expect(current_path).to eq("/merchant/orders/#{@order.id}")
          expect(page).to have_content("You have fulfilled #{@enough_inventory.quantity} of #{@enough_inventory.item.name}")

          within ("section#item-#{@enough_inventory.item_id}") do
            expect(page).to have_content("- FULFILLED")

            expect(page).to_not have_button("Fulfill Items")
          end
        end

        it "Fulfilling an item reduces the item inventory by the customer's desired quantity" do
          expect(Item.find(@item1.id).inventory).to eq(1)

          within ("section#item-#{@enough_inventory.item_id}") do
            click_button "Fulfill Items"
          end

          expect(Item.find(@item1.id).inventory).to eq(0)
        end
      end

      describe "I cannot fulfill an order due to lack of inventory" do
        it "There is no button and there is a notice next to the item" do
          within ("section#item-#{@lacking_inventory.item_id}") do
            expect(page).to_not have_button("Fulfill Items")
            expect(page).to have_content("You cannot fulfill this item due to lack of inventory")
          end
        end
      end
    end
  end
end
