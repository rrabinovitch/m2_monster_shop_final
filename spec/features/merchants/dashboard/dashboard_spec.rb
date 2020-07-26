require 'rails_helper'

RSpec.describe 'As a merchant employee' do
  describe 'When I visit the merchant dashboard' do
    before :each do
      @merchant = create(:merchant)
      @merchant_employee = create(:user, role: 1, merchant_id: @merchant.id)
      visit '/login'
      fill_in :email, with: @merchant_employee.email
      fill_in :password, with: @merchant_employee.password
      click_button 'Log In'

      @merchant2 = create(:merchant)


      @item1 = create(:item, merchant_id: @merchant.id)
      @item2 = create(:item, merchant_id: @merchant.id)
      @item3 = create(:item, merchant_id: @merchant.id)
      @item4 = create(:item, merchant_id: @merchant2.id)

      @order1 = create(:order)
      @order2 = create(:order)

      @order1.item_orders.create(item: @item1, price: 5, quantity: 1)
      @order1.item_orders.create(item: @item2, price: 10, quantity: 5)
      @order1.item_orders.create(item: @item3, price: 50, quantity: 3)
      @order1.item_orders.create(item: @item4, price: 10, quantity: 10)
      @order2.item_orders.create(item: @item1, price: 5, quantity: 1)
    end
    it 'I see the name and address of the merchant I work for' do
      visit "/merchant/dashboard"

      expect(page).to have_content(@merchant.name)
      expect(page).to have_content(@merchant.address)
      expect(page).to have_content(@merchant.city)
      expect(page).to have_content(@merchant.state)
      expect(page).to have_content(@merchant.zip)
    end

    it 'I can also see a list of pending orders that include items sold by my merchant, including the order ID, order date, total quantity of my merchant items in the order, and the total value of my merchant items for that order' do
    end

    it 'the order ID is a link to the merhant order show page' do

    end
  end
end
