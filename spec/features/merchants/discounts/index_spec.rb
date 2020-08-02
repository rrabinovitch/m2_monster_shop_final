require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before :each do
    @merchant = create(:merchant)
    @merchant_employee = create(:user, role: 1, merchant: @merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    visit merchant_path
  end

  it "When I visit my merchant dashboard, I see a link to view the discounts associated with my shop." do
    expect(page).to have_link("Bulk Discounts")
  end

  it "When I click this link, I see a list of my shop's discounts, including each discount's percentage and quantity requirements." do
    click_on "Bulk Discounts"
    # expect(page).to have_content() # discount #1 percentage and quantity requirements
    # expect(page).to have_content() # discount #2 percentage and quantity requirements
  end

  it "The discounts index also has a link to create a new discount." do
    click_on "Bulk Discounts"
    expect(page).to have_link("New Bulk Discount")
  end
end
