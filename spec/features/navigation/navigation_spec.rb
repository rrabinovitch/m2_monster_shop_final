require 'rails_helper'

RSpec.describe 'Site Navigation' do
  before :each do
    @user = User.create(name: "Jane Doe",
                        address: "123 Palm St",
                        city: "Chicago",
                        state: "IL",
                        zip: 60623,
                        email: "janedoe@email.com",
                        password: "password",
                        password_confirmation: "password")
    @merchant1 = User.create(name: "Megan Stang",
                                 address: "456 Cool St",
                                 city: "Denver",
                                 state: "CO",
                                 zip: 80203,
                                 email: "megstang@email.com",
                                 password: "password",
                                 password_confirmation: "password",
                                 role: 1)
  end

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
        click_link 'Log In'
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
    it "Plus a link to my profile page and a link to log out, but no links to log in or register" do
      visit '/login'
      fill_in :email, with: @user.email
      fill_in :password, with: "password"
      click_button 'Log In'
      expect(current_path).to eq("/profile")
      expect(page).to have_content("Logged in as #{@user.name}")
      expect(page).to have_link("Log Out")
      expect(page).to_not have_link("Log In")
      expect(page).to_not have_link("Register")
    end
  end

  describe 'As a Merchant Employee: I see the same links as a Regular Visitor' do
    it "Plus a link to my merchant dashboard" do
      visit '/login'
      fill_in :email, with: @merchant1.email
      fill_in :password, with: "password"
      click_button 'Log In'
      expect(current_path).to eq("/merchant/dashboard")
      expect(page).to have_content("Logged in as #{@merchant1.name}")
      expect(page).to have_link("My Dashboard")
      expect(page).to have_link("Log Out")
      expect(page).to_not have_link("Log In")
      expect(page).to_not have_link("Register")
    end
  end

end
