require "rails_helper"

RSpec.describe "New User Registration Validation Spec" do
  before :each do
    @user = build(:user)

    expect(User.all).to_not include(@user)

    visit "/register"
  end

  describe "As a visitor" do
    describe "When I visit the user registration page" do
      describe "I cannot register if I do not fill out the" do
        it "name field" do

          fill_in :address, with: @user.address
          fill_in :city, with: @user.city
          fill_in :state, with: @user.state
          fill_in :zip, with: @user.zip
          fill_in :email, with: @user.email
          fill_in :password, with: @user.password
          fill_in :confirm_password, with: @user.password

          click_button "Register as a New User"

          expect(User.all.count).to eq(0)

          expect(current_path).to eq("/register")
          expect(page).to have_content("All fields must be completed before submitting:")
          expect(page).to have_content("Name can't be blank")

        end

        it "address field" do
          fill_in :name, with: @user.name

          fill_in :city, with: @user.city
          fill_in :state, with: @user.state
          fill_in :zip, with: @user.zip
          fill_in :email, with: @user.email
          fill_in :password, with: @user.password
          fill_in :confirm_password, with: @user.password

          click_button "Register as a New User"

          expect(User.all.count).to eq(0)

          expect(current_path).to eq("/register")

          expect(page).to have_content("All fields must be completed before submitting:")
          expect(page).to have_content("Address can't be blank")
        end

        it "city field" do
          fill_in :name, with: @user.name
          fill_in :address, with: @user.address

          fill_in :state, with: @user.state
          fill_in :zip, with: @user.zip
          fill_in :email, with: @user.email
          fill_in :password, with: @user.password
          fill_in :confirm_password, with: @user.password

          click_button "Register as a New User"

          expect(User.all.count).to eq(0)

          expect(current_path).to eq("/register")
          expect(page).to have_content("All fields must be completed before submitting:")
          expect(page).to have_content("City can't be blank")
        end

        it "state field" do
          fill_in :name, with: @user.name
          fill_in :address, with: @user.address
          fill_in :city, with: @user.city

          fill_in :zip, with: @user.zip
          fill_in :email, with: @user.email
          fill_in :password, with: @user.password
          fill_in :confirm_password, with: @user.password

          click_button "Register as a New User"

          expect(User.all.count).to eq(0)

          expect(current_path).to eq("/register")
          expect(page).to have_content("All fields must be completed before submitting:")
          expect(page).to have_content("State can't be blank")
        end

        it "zip field" do
          fill_in :name, with: @user.name
          fill_in :address, with: @user.address
          fill_in :city, with: @user.city
          fill_in :state, with: @user.state

          fill_in :email, with: @user.email
          fill_in :password, with: @user.password
          fill_in :confirm_password, with: @user.password

          click_button "Register as a New User"

          expect(User.all.count).to eq(0)

          expect(current_path).to eq("/register")
          expect(page).to have_content("All fields must be completed before submitting:")
          expect(page).to have_content("Zip is not a number")
        end

        it "email field" do
          fill_in :name, with: @user.name
          fill_in :address, with: @user.address
          fill_in :city, with: @user.city
          fill_in :state, with: @user.state
          fill_in :zip, with: @user.zip

          fill_in :password, with: @user.password
          fill_in :confirm_password, with: @user.password

          click_button "Register as a New User"

          expect(User.all.count).to eq(0)

          expect(current_path).to eq("/register")
          expect(page).to have_content("All fields must be completed before submitting:")
          expect(page).to have_content("Email can't be blank")
        end

        it "a combination of fields" do
          fill_in :name, with: @user.name
          fill_in :address, with: @user.address
          fill_in :city, with: @user.city

          click_button "Register as a New User"

          expect(User.all.count).to eq(0)

          expect(current_path).to eq("/register")
          expect(page).to have_content("All fields must be completed before submitting:")

          expect(page).to have_content("State can't be blank")
          expect(page).to have_content("Zip is not a number")
          expect(page).to have_content("Email can't be blank")
          expect(page).to have_content("Password can't be blank")
        end

        it "all fields" do
          click_button "Register as a New User"

          expect(User.all.count).to eq(0)

          expect(current_path).to eq("/register")
          expect(page).to have_content("All fields must be completed before submitting:")

          expect(page).to have_content("Name can't be blank")
          expect(page).to have_content("Address can't be blank")
          expect(page).to have_content("City can't be blank")
          expect(page).to have_content("State can't be blank")
          expect(page).to have_content("Zip is not a number")
          expect(page).to have_content("Email can't be blank")
          expect(page).to have_content("Password can't be blank")

        end

        it "password field" do
          fill_in :name, with: @user.name
          fill_in :address, with: @user.address
          fill_in :city, with: @user.city
          fill_in :state, with: @user.state
          fill_in :zip, with: @user.zip
          fill_in :email, with: @user.email

          fill_in :confirm_password, with: @user.password

          click_button "Register as a New User"

          expect(User.all.count).to eq(0)

          expect(current_path).to eq("/register")
          expect(page).to have_content("All fields must be completed before submitting:")
          expect(page).to have_content("Passwords do not match")
        end

        it "confirm password field" do
          fill_in :name, with: @user.name
          fill_in :address, with: @user.address
          fill_in :city, with: @user.city
          fill_in :state, with: @user.state
          fill_in :zip, with: @user.zip
          fill_in :email, with: @user.email
          fill_in :password, with: @user.password

          click_button "Register as a New User"

          expect(User.all.count).to eq(0)

          expect(current_path).to eq("/register")
          expect(page).to have_content("All fields must be completed before submitting:")
          expect(page).to have_content("Passwords do not match")
        end

        it "password and confirm password field must be the same password" do
          fill_in :name, with: @user.name
          fill_in :address, with: @user.address
          fill_in :city, with: @user.city
          fill_in :state, with: @user.state
          fill_in :zip, with: @user.zip
          fill_in :email, with: @user.email
          fill_in :password, with: @user.password
          fill_in :confirm_password, with: "not_the_password"

          click_button "Register as a New User"

          expect(User.all.count).to eq(0)

          expect(current_path).to eq("/register")
          expect(page).to have_content("All fields must be completed before submitting:")
          expect(page).to have_content("Passwords do not match")
        end
      end
    end
  end
end
