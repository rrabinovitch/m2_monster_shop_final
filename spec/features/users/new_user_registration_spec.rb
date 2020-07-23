require "rails_helper"

RSpec.describe "New User Registration Spec" do
  before :each do
    @user = build(:user)
  end

  describe "As a visitor" do
    describe "After I click 'register' in the nav bar" do
      it "I can register to become a user" do
        visit "/items"

        click_link "Register"

        expect(current_path).to eq("/register")

        expect(User.all.count).to eq(0)

        fill_in :name, with: @user.name
        fill_in :address, with: @user.address
        fill_in :city, with: @user.city
        fill_in :state, with: @user.state
        fill_in :zip, with: @user.zip
        fill_in :email, with: @user.email
        fill_in :password, with: @user.password
        fill_in :confirm_password, with: @user.password

        click_button "Register as a New User"

        expect(User.all.count).to eq(1)

        expect(current_path).to eq("/profile")

        expect(page).to have_content("You are now registered and logged in!")
      end
    end
  end
end
