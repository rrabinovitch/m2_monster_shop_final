require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before :each do
    @merchant = create(:merchant)
    @merchant_employee = create(:user, role: 1, merchant: @merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  it "When I visit my shop's discounts index page, I can click a link to create a new discount." do
    visit "/merchant/discounts"
    click_on "New Bulk Discount"
    expect(current_path).to eq("/merchant/discounts/new")
  end

  it "I am taken to a form where I am prompted to input a discount percentage and a minimum item quantity to create a discount.
      When I submit the form, I am returned to the discounts index page, where I see the new discount's information listed." do
    visit "/merchant/discounts"
    click_on "New Bulk Discount"
    fill_in "Percentage", with: 25
    fill_in "Minimum item quantity", with: 10
    click_on "Create Discount"
    expect(page).to have_content("25% off 10 or more items")
  end
end
