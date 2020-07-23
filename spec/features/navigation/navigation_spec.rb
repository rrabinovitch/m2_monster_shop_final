require 'rails_helper'

RSpec.describe 'Site Navigation' do

  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do

      visit '/'

      within 'nav' do
        click_link 'Home'
      end
      expect(current_path).to eq('/')

      within 'nav' do
        click_link 'All Items'
      end
      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end
      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Cart'
      end
      expect(current_path).to eq('/cart')

      within 'nav' do
        click_link 'Login'
      end
      expect(current_path).to eq('/login')

      within 'nav' do
        click_link 'Register'
      end
      expect(current_path).to eq('/register')
    end

    it "I can see a cart indicator on all pages" do

      visit '/items'
      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/merchants'
      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end
  end

  describe 'As a Regular User: I see the same links as a visitor' do
    it "Plus a link to my profile page and a link to log out " do
      visit "/"

    end

    xit "Minus a link to log in or register" do

    end

    xit "And I see a text that says I am logged in with my name" do

    end
  end
#   As a default user
# I see the same links as a visitor
# Plus the following links
#
# a link to my profile page ("/profile")
# a link to log out ("/logout")
# Minus the following links
#
# I do not see a link to log in or register
# I also see text that says "Logged in as Mike Dao" (or whatever my name is)
end
