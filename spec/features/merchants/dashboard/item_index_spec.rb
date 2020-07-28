require 'rails_helper'

RSpec.describe 'As a merchant employee' do
  describe 'When I visit the merchant dashboard' do
    describe 'And click on the merchant items link' do
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
    end

      it "the merchant items link takes me to the merchant items index page" do
        visit "/merchant/dashboard"
        expect(page).to have_link "Merchant Items"
        click_link "Merchant Items"
        expect(current_path).to eq("/merchant/items")
        expect(page).to have_content(@item1.name)
        expect(page).to have_content(@item2.name)
        expect(page).to have_content(@item3.name)
        expect(page).to_not have_content(@item4.name)
      end

    end
  end
end
