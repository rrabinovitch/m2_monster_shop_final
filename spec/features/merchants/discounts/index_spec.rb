require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before :each do
    @merchant = create(:merchant)
    @merchant_employee = create(:user, role: 1, merchant: @merchant)
    @discount_1 = @merchant.discounts.create(percentage: 25, minimum_item_quantity: 10)
    @discount_1 = @merchant.discounts.create(percentage: 30, minimum_item_quantity: 15)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    visit merchant_path
  end

  it "When I visit my merchant dashboard, I see a link to view the discounts associated with my shop." do
    expect(page).to have_link("Bulk Discounts")
  end

  it "When I click this link, I see a list of my shop's discounts, including each discount's percentage and quantity requirements." do
    click_on "Bulk Discounts"
    expect(page).to have_content("25% off 10 or more items")
    expect(page).to have_content("30% off 15 or more items")
  end

  it "The discounts index also has a link to create a new discount." do
    click_on "Bulk Discounts"
    expect(page).to have_link("New Bulk Discount")
  end
end
