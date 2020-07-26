require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe "status" do
    before :each do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      customer = create(:user)
      order_1 = customer.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @unfulfilled_item_order = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 0)
      @fulfilled_item_order = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 1)
    end

    it "can be unfulfilled" do
      expect(@unfulfilled_item_order.status).to eq("unfulfilled")
      expect(@unfulfilled_item_order.unfulfilled?).to be_truthy
    end

    it "can be fulfilled" do
      expect(@fulfilled_item_order.status).to eq("fulfilled")
      expect(@fulfilled_item_order.fulfilled?).to be_truthy
    end
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

end
