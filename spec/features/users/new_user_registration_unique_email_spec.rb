require "rails_helper"

RSpec.describe "New User Registration Unique Emails Spec" do
  before :each do
    @user1 = create(:user, email: "user1@email.com")
    @user2 = build(:user, email: "user1@email.com")

    expect(User.all).to include(@user1)
    expect(User.all).to_not include(@user2)
  end

  describe "As a visitor" do
    describe "If I fill out the new user registration form" do
      it "It will not let me register if the email address already in the system" do
        visit register_path

        fill_in :name, with: @user2.name
        fill_in :address, with: @user2.address
        fill_in :city, with: @user2.city
        fill_in :state, with: @user2.state
        fill_in :zip, with: @user2.zip
        fill_in :email, with: @user2.email
        fill_in :password, with: @user2.password
        fill_in :confirm_password, with: @user2.password

        click_button "Register as a New User"

        expect(User.all).to_not include(@user2)

        expect(current_path).to eq(register_path)

        expect(page).to have_content("Email has already been taken")

        expect(page).to have_selector("input[value='#{@user2.name}']")
        expect(page).to have_selector("input[value='#{@user2.address}']")
        expect(page).to have_selector("input[value='#{@user2.city}']")
        expect(page).to have_selector("input[value='#{@user2.state}']")
        expect(page).to have_selector("input[value='#{@user2.zip}']")

        expect(page).to_not have_selector("input[value='#{@user2.email}']")
        expect(page).to_not have_selector("input[value='#{@user2.password}']")
      end
    end
  end
end
