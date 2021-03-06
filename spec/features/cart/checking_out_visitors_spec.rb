require "rails_helper"

RSpec.describe "Cart show" do
  before :each do
    @item = create(:item)
    visit "/items/#{@item.id}"
    click_on "Add To Cart"
  end

  describe "As a visitor when I have items in my cart" do
    it "I must register or log in to finish the checkout process" do
      visit cart_path
      within('.warning') do
        expect(page).to have_content("You must Register or Log In to finish the checkout process")
        expect(page).to have_link("Register", href: "/register")
        expect(page).to have_link("Log In", href: "/login")
      end
      click_on "Checkout"

      fill_in :name, with: "Rose"
      fill_in :address, with: "Cool Street"
      fill_in :city, with: "Rubyville"
      fill_in :state, with: "CO"
      fill_in :zip, with: 111111

      click_button "Create Order"
      expect(page).to have_content("Please login or register in order to checkout.")
    end
  end

  describe "As a user when I have items in my cart" do
    it "I do not see the warning message" do
      default_user = create(:user)

      visit cart_path

      within('.warning') do
        click_on "Log In"
      end

      fill_in :email, with: default_user.email
      fill_in :password, with: default_user.password
      click_button 'Log In'

      visit cart_path
      expect(page).to_not have_css('.warning')
    end
  end
end
