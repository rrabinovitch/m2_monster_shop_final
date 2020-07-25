require 'rails_helper'

RSpec.describe 'As a user' do
  describe 'when I visit the items index page' do
    describe "I see statistics for all items" do
      before(:each) do
        @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @item1 = create(:item, merchant_id: @bike_shop.id)
        @item2 = create(:item, merchant_id: @bike_shop.id)
        @item3 = create(:item, merchant_id: @bike_shop.id)
        @item4 = create(:item, merchant_id: @bike_shop.id)
        @item5 = create(:item, merchant_id: @bike_shop.id)
        @item6 = create(:item, merchant_id: @bike_shop.id)
        @item7 = create(:item, merchant_id: @bike_shop.id)
        @item8 = create(:item, merchant_id: @bike_shop.id)
        @item9 = create(:item, merchant_id: @bike_shop.id)
        @item10 = create(:item, merchant_id: @bike_shop.id)

        order = create(:order)

        order.item_orders.create(item: @item1, price: 5, quantity: 1)
        order.item_orders.create(item: @item2, price: 5, quantity: 2)
        order.item_orders.create(item: @item3, price: 5, quantity: 3)
        order.item_orders.create(item: @item4, price: 5, quantity: 4)
        order.item_orders.create(item: @item5, price: 5, quantity: 5)
        order.item_orders.create(item: @item6, price: 5, quantity: 6)
        order.item_orders.create(item: @item7, price: 5, quantity: 7)
        order.item_orders.create(item: @item8, price: 5, quantity: 8)
        order.item_orders.create(item: @item9, price: 5, quantity: 9)
        order.item_orders.create(item: @item10, price: 5, quantity: 10)
      end

      it 'shows the top 5 most popular items by quantity purchased, plus the quantity bought' do

        visit "/items"
        within ".least_popular" do
          expect(page).to have_content("Least Popular Items")
          expect(page).to have_content(@item1.name)
          expect(page).to have_content(@item1.total_sold)
          expect(page).to have_content(@item2.name)
          expect(page).to have_content(@item2.total_sold)
          expect(page).to have_content(@item3.name)
          expect(page).to have_content(@item3.total_sold)
          expect(page).to have_content(@item4.name)
          expect(page).to have_content(@item4.total_sold)
          expect(page).to have_content(@item5.name)
          expect(page).to have_content(@item5.total_sold)
        end

        within ".most_popular" do
          expect(page).to have_content("Most Popular Items")
          expect(page).to have_content(@item10.name)
          expect(page).to have_content(@item10.total_sold)
          expect(page).to have_content(@item9.name)
          expect(page).to have_content(@item9.total_sold)
          expect(page).to have_content(@item8.name)
          expect(page).to have_content(@item8.total_sold)
          expect(page).to have_content(@item7.name)
          expect(page).to have_content(@item7.total_sold)
          expect(page).to have_content(@item6.name)
          expect(page).to have_content(@item6.total_sold)
        end
      end
    end
  end
end
