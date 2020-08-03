require 'rails_helper'

RSpec.describe "As a merchant employee" do
  before :each do
    @merchant = create(:merchant)
    @merchant_employee = create(:user, role: 1, merchant: @merchant)
    @discount_1 = @merchant.discounts.create(percentage: 25, minimum_item_quantity: 10)
    @discount_2 = @merchant.discounts.create(percentage: 30, minimum_item_quantity: 15)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    visit merchant_discounts_path
  end

  it "When I visit my shop's discounts index page, I see a 'delete' button next to each discount." do
    within "#discount-#{@discount_1.id}" do
      expect(page).to have_button("Delete")
    end
    within "#discount-#{@discount_2.id}" do
      expect(page).to have_button("Delete")
    end
  end

  it "When I click on a discount's 'delete' button, I see the discounts index page no longer lists the deleted discount and a flash message is displayed." do
    within("#discount-#{@discount_1.id}") do
      click_button "Delete"
    end
    expect(current_path).to eq(merchant_discounts_path)
    expect(page).to have_content("Discount has been deleted")
    expect(page).to_not have_content("25% off 10 or more items")
    expect(page).to have_content("30% off 15 or more items")
  end
end
