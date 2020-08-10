require "rails_helper"

RSpec.describe "Merchant Order Show Page Spec" do
  before :each do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)

    @item1 = create(:item, merchant: @merchant1)
    @item2 = create(:item, merchant: @merchant1)
    @item3 = create(:item, merchant: @merchant2)

    @order = create(:order)

    @item_order1 = @order.item_orders.create!(item: @item1, price: @item1.price, quantity: 2)
    @item_order2 = @order.item_orders.create!(item: @item2, price: @item2.price, quantity: 3)
    @item_order3 = @order.item_orders.create!(item: @item3, price: @item3.price, quantity: 3)

    @order = Order.all.first
    @merchant1 = Merchant.all.first
    @merchant2 = Merchant.all.last

    @merchant_employee = create(:user, role: 1, merchant: @merchant1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    visit merchant_dashboard_index_path
    click_link(@order.id, href: "/merchant/orders/#{@order.id}")
  end

  describe "As a merchant employee" do
    describe "I visit an order show page from my dashboard" do
      it "I see the recipients name and address that was used to create this order" do
        within ".shipping-address" do
          expect(page).to have_content(@order.name)
          expect(page).to have_content(@order.address)
          expect(page).to have_content(@order.city)
          expect(page).to have_content(@order.state)
          expect(page).to have_content(@order.zip)
        end
      end
      it "I only see the items in the order that are being purchased from my merchant" do
        expect(page).to have_css("section#item-#{@item_order1.item_id}")
        expect(page).to have_css("section#item-#{@item_order2.item_id}")
      end

      it "I do not see any items in the order being purchased from other merchants" do
        expect(page).to_not have_css("section#item-#{@item_order3.item_id}")
      end

      it "I see each item's image, price and quantity ordered and a link to its show page" do
        within "section#item-#{@item_order1.item_id}" do
          expect(page).to have_link(@item1.name, href: "/items/#{@item1.id}")

          thumbnail_image = find('.item-thumbnail')
          expect(thumbnail_image[:src]).to eq(@item1.image)
          expect(thumbnail_image[:alt]).to eq("Photo of #{@item1.name}")

          expect(page).to have_content(@item_order1.price)
          expect(page).to have_content(@item_order1.quantity)
        end

        within "section#item-#{@item_order2.item_id}" do
          expect(page).to have_link(@item2.name, href: "/items/#{@item2.id}")

          thumbnail_image = find('.item-thumbnail')
          expect(thumbnail_image[:src]).to eq(@item2.image)
          expect(thumbnail_image[:alt]).to eq("Photo of #{@item2.name}")

          expect(page).to have_content(@item_order2.price)
          expect(page).to have_content(@item_order2.quantity)
        end
      end
    end
  end
end
