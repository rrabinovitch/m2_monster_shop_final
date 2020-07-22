require 'rails_helper'

RSpec.describe 'User Login Spec' do
  describe 'When I visit the login page' do

    it 'I can log in with valid credentials email and password' do
      user = create(:user)
      visit '/login'
      fill_in :name, with: user.name
      fill_in :password, with: user.password
      click_on 'Log In'
      expect(current_path).to eq("/profile")
      expect(page).to have_content("You are now logged in!")
    end

    it 'If I am a regular user, I am redirected to my profile page. A flash message will confirm I am logged in' do
    end

    it 'If I am a merchant user, I am redirected to my merchant dashbpard page. A flash message will confirm I am logged in' do
    end

    it 'If I am a admin user, I am redirected to my admin dashboard page. A flash message will confirm I am logged in'
  end
end
