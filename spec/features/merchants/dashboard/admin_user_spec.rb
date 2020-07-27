require 'rails_helper'

RSpec.describe "As an admin" do
  describe "When I visit the merchant index page" do
    describe 'And click on the link of the merchant name' do
      it 'I am taken to /admin/merchant/merchant_id' do
        @merchant = create(:merchant)
        @admin_user = create(:user, role: 2)
        visit '/login'
        fill_in :email, with: @admin_user.email
        fill_in :password, with: @admin_user.password
        click_button 'Log In'


        visit "/merchants"

        expect(@admin_user.admin?).to be_truthy
        click_on @merchant.name
        expect(page).to have_current_path("/admin/merchants/#{@merchant.id}")

        expect(page).to have_content("Pending Orders for #{@merchant.name}")
      end
    end
  end
end
