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

  it "When I visit my shop's discount index page, I see an 'edit' button next to each discount." do
    within("#discount-#{@discount_1.id}") do
      expect(page).to have_button("Edit")
    end
    within("#discount-#{@discount_2.id}") do
      expect(page).to have_button("Edit")
    end
  end

  it "When I click on a discount's edit button, I am taken to a form that is pre-populated with that discount's info." do
    within("#discount-#{@discount_1.id}") do
      click_button "Edit"
    end
    expect(current_path).to eq("/merchant/discounts/#{@discount_1}/edit")
    expect(page).to have_content(@discount_1.percentage)
    expect(page).to have_content(@discount_1.minimum_item_quantity)
  end

  it "When I fill out the edit discount form successfully, I am returned to the discounts index page where I see the updated info for that discount displayed,
      as well as a flash message indiciating it was successfully updated." do
    visit "/merchant/discount/#{@discount_1}/edit"
    fill_in "Percentage", with: 40
    click_on "Update Discount"
    expect(current_path).to eq(merchant_discounts_path)
    expect(page).to have_content("40% off 10 or more items")
  end

  it "When I fill out the edit discount form and have left a field empty, I remain on the discount edit form page,
      and I see a flash message prompting me to re-fill the form." do
    visit "/merchant/discount/#{@discount_1}/edit"
    fill_in "Percentage", with: ""
    click_on "Update Discount"
    expect(page).to have_content("All form fields must be filled in order to update a discount.")
    expect(current_path).to eq("/merchant/discount/#{@discount_1}/edit")
  end
end
