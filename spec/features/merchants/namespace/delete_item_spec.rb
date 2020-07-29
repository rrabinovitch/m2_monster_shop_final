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

    it "any items that have never been ordered have a link to delete that item" do
      within("#item-#{@item1.id}") do
        expect(page).to have_link("Delete")
      end
      within("#item-#{@item2.id}") do
        expect(page).to_not have_link("Delete")
      end
    end

    it "clicking on that link will delete the item, show a flash message confirming the item deletion, and return me to my items index page" do
      within("#item-#{@item1.id}") do
        click_on "Delete"
      end
      expect(current_path).to eq("/merchant/items")
      expect(page).to_not have_content(@item1.description)
      expect(page).to have_content("#{@item1.name} has been deleted.")
    end
  end
end
