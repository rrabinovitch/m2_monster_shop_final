require 'rails_helper'

RSpec.describe 'As a merchant' do
  describe 'When I visit the merchant dashboard' do
    before :each do
      @merchant = create(:merchant)
      @merchant_employee = create(:user, role: 1, merchant_id: @merchant.id)
      visit '/login'
      fill_in :email, with: @merchant_employee.email
      fill_in :password, with: @merchant_employee.password
      click_button 'Log In'

    end
    it 'I see the name and address of the merchant I work for' do
      visit "/merchant/dashboard"
      expect(page).to have_content("Merchant Dashboard")
      expect(page).to have_content(@merchant.name)
      expect(page).to have_content(@merchant.address)
      expect(page).to have_content(@merchant.city)
      expect(page).to have_content(@merchant.state)
      expect(page).to have_content(@merchant.zip)
    end
  end
end
