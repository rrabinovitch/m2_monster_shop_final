require 'rails_helper'

RSpec.describe 'User can log out' do
  describe "When I visit the logout path" do
    it "I am redirected to the site's home page, I see a flash message indicating I'm logged out, and my shopping cart is emptied" do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      item = create(:item)
      visit "/items/#{item.id}"
      click_on "Add To Cart"
      within('.topnav') do
        expect(page).to have_content("Cart: 1")
      end

      visit '/logout'
      expect(current_path).to eq('/')
      expect(page).to have_content("You have been logged out.")
      within('.topnav') do
        expect(page).to have_content("Cart: 0")
      end
    end
  end
end
