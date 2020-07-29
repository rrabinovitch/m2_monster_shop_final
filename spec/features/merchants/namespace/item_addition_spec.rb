require 'rails_helper'

RSpec.describe 'As a merchant employee' do
  describe 'When I visit the merchant items index page' do
    before :each do
      @merchant = create(:merchant)
      @merchant_employee = create(:user, role: 1, merchant_id: @merchant.id)
      visit '/login'
      fill_in :email, with: @merchant_employee.email
      fill_in :password, with: @merchant_employee.password
      click_button 'Log In'

      @item1 = create(:item, merchant_id: @merchant.id, description: "it's ok")
      @item2 = create(:item, merchant_id: @merchant.id)
      @item3 = create(:item, merchant_id: @merchant.id)
      @order = create(:order)

      ItemOrder.create(item: @item2, order: @order, price: 5, quantity: 2)
      visit "/merchant/items"
    end

    it "I see a link to add a new item" do
      expect(page).to have_link("Add Item")
    end

    it "clicking on a link takes me a form to fill out the information of the new item detail" do

    end

    it "upon submitting the form, I am taken back to the items index page, and a message confirms the addition of the new item" do

    end
  end
end
