require "rails_helper"

RSpec.describe "New User Registration Spec" do
  before :each do
    # @items = create_list(:item, 5)
  end

  describe "As a visitor" do
    describe "After I click 'register' in the nav bar" do
      it "I can register to become a user" do
        visit "/items"

        click_link "Register"

        expect(current_path).to eq("/register")

        expect(User.all.count).to eq(0)

        fill_in :name, with: "AJ"
        fill_in :address, with: "Cool Street"
        fill_in :city, with: "Denver"
        fill_in :state, with: "CO"
        fill_in :zip, with: 80239
        fill_in :email, with: "my_email@email.com"
        fill_in :password, with: "my_password"
        fill_in :confirm_password, with: "my_password"

        click_button "Register as a New User"

        expect(User.all.count).to eq(1)

        expect(current_path).to eq("/profile")

        expect(page).to have_content("You are now registered and logged in!")
      end
    end
  end
end
