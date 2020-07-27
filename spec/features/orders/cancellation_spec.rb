require "rails_helper"

RSpec.describe "Order Cancellation Spec" do
  before :each do
    @merchant1 = create(:merchant)
    @gizmos = create(:item, merchant: @merchant1, name: "Gizmos", price: 10, inventory: 10)

    @merchant2 = create(:merchant)
    @doodads = create(:item, merchant: @merchant2, name: "Doo Dads", price: 12, inventory: 5)

    @customer = create(:user)
    @order = create(:order, user: @customer)
    @order.item_orders.create(item: @gizmos, price: @gizmos.price, quantity: 3, status: 0)
    @order.item_orders.create(item: @doodads, price: @doodads.price, quantity: 2, status: 1)

    visit login_path
    fill_in :email, with: @customer.email
    fill_in :password, with: @customer.password
    click_button 'Log In'

    visit "/profile/orders/#{@order.id}"
  end

  describe "As a registered user" do
    describe "When I visit an order's show page, I can cancel an order" do
      it "I see a button or link to cancel the order" do
        expect(page).to have_button("Cancel Order")
      end
    end

    describe "The following happens when I click the cancel button" do
      it "Each row in the 'order items' table is given a status of 'unfulfilled'" do
        click_button "Cancel Order"
        expect(Order.all.first.item_orders.all?(&:unfulfilled?)).to be_truthy
      end

      it "The order itself is given a status of 'cancelled'" do
        click_button "Cancel Order"
        expect(Order.all.first.status).to eq("cancelled")
        expect(Order.all.first.cancelled?).to be_truthy
      end

      it "Merchants restock their inventory with previously fulfilled items" do
        expect(Item.find(@doodads.id).inventory).to eq(5)
        click_button "Cancel Order"
        expect(Item.find(@doodads.id).inventory).to eq(7)
      end

      it "I am returned to my profile page and to see the order updated" do
        click_button "Cancel Order"
        expect(current_path).to eq("/profile")
        expect(page).to have_content("The order is now cancelled")

        visit "/profile/orders"
        within "section.order-#{@order.id}" do
          expect(page).to have_content("Status: cancelled")
        end
      end
    end
  end
end
