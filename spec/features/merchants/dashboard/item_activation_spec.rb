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

      @merchant2 = create(:merchant)

      @item1 = create(:item, merchant_id: @merchant.id)
      @item2 = create(:item, merchant_id: @merchant.id)
      @item3 = create(:item, merchant_id: @merchant.id)
      @item4 = create(:item, merchant_id: @merchant2.id)
      visit "/merchant/items"
    end

    it "I see a list of all items with the following information: name, desciption, price, image, status, and inventory" do
      within("#item-#{@item1.id}") do
        expect(page).to have_content(@item1.name)
        expect(page).to have_content(@item1.description)
        expect(page).to have_content(@item1.price)
        expect(page).to have_content(@item1.image)
        expect(page).to have_content(@item1.active?)
        expect(page).to have_content(@item1.inventory)
      end
        expect(page).to_not have_content(@item4.name)
    end

  end
end
