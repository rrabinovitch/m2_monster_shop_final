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
      expect(page).to have_content("You have logged out.")
      within('.topnav') do
        expect(page).to have_content("Cart: 0")
      end

      # add expectation to confirm that @current_user does not exist anymore
    end
  end
end


# log in button should not exist when someone's logged in - take care of this in view logic
# if someone were to type in the login url path, they should be redirected like
