require "rails_helper"

RSpec.describe "New User Registration Validation Spec" do
  before :each do
    @user = build(:user)

    expect(User.all.count).to eq(0)

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
            expect(page).to have_content("Please fill in the missing fields: name.")
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
          expect(page).to have_content("Please fill in the missing fields: address.")
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
          expect(page).to have_content("Please fill in the missing fields: city.")
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
          expect(page).to have_content("Please fill in the missing fields: state.")
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
          expect(page).to have_content("Please fill in the missing fields: zip.")
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
          expect(page).to have_content("Please fill in the missing fields: email.")
        end

        it "a combination of fields" do
          fill_in :name, with: @user.name
          fill_in :address, with: @user.address
          fill_in :city, with: @user.city

          click_button "Register as a New User"

          expect(User.all.count).to eq(0)

          expect(current_path).to eq("/register")
          expect(page).to have_content("Please fill in the missing fields: state, zip, email, password.")
        end

        it "all fields" do
          click_button "Register as a New User"

          expect(User.all.count).to eq(0)

          expect(current_path).to eq("/register")
          expect(page).to have_content("Please fill in the missing fields: name, address, city, state, zip, email, password.")
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
          expect(page).to have_content("Please fill in the missing fields: password.")
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
          expect(page).to have_content("Please fill in the missing fields: confirm password.")
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
          expect(page).to have_content("Please fill in the missing fields: confirm password.")
        end
      end
    end
  end
end
