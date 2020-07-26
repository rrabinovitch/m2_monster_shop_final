require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'instance methods' do
    it 'subtotal' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      customer = create(:user)
      order_1 = customer.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)

      expect(item_order_1.subtotal).to eq(200)
    end
  end

  describe 'class methods' do
    before :each do
      @user = create(:user)
      @item1 = create(:item)
      @item2 = create(:item)
      @order = create(:order)
      @user.orders << @order
      @item1.item_orders.create(order: @order, price: @item1.price, quantity: 2)
      @item2.item_orders.create(order: @order, price: @item1.price, quantity: 5)
    end

    it '.select_items_in_order(order)' do
      expect(ItemOrder.select_items_in_order(@item1)).to eq([@item1.item_orders.first])
    end

    it '.items_in_order_quantity' do
      expect(ItemOrder.items_in_order_quantity(@item1)).to eq(2)
    end

    it '.item_order_subtotal' do
      expect(ItemOrder.item_order_subtotal(@item1)).to eq(@item1.price * @order.item_orders.items_in_order_quantity(@item1))
    end
  end
end
