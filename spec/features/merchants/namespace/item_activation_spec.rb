require 'rails_helper'

RSpec.describe 'As a merchant employee' do
  describe 'When I visit the merchant items index page' do
    before :each do
      @merchant = create(:merchant)
      @merchant_employee = create(:user, role: 1, merchant_id: @merchant.id)
      visit '/login'
      fill_in :email, with: @merchant_employee.email
      fill_in :password, with: @merchant_employee.password
      click_button 'Log In'

      @merchant2 = create(:merchant)

      @item1 = create(:item, merchant_id: @merchant.id)
      @item2 = create(:item, merchant_id: @merchant.id)
      @item3 = create(:item, merchant_id: @merchant.id)
      @item4 = create(:item, merchant_id: @merchant2.id)
      @item5 = create(:item, merchant_id: @merchant.id, active?: false)
      visit "/merchant/items"
    end

    it "I see a list of all items with the following information: name, desciption, price, image, status, and inventory" do
      within("#item-#{@item1.id}") do
        expect(page).to have_content(@item1.name)
        expect(page).to have_content(@item1.description)
        expect(page).to have_content(@item1.price)
        expect(page).to have_content(@item1.image)
        expect(page).to have_content("Active")
        expect(page).to have_content(@item1.inventory)
      end
        expect(page).to_not have_content(@item4.name)
    end

    it "Active items will have a Deactivate link to deactive that item." do
      within("#item-#{@item1.id}") do
        click_on "Deactivate"
      end
      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{@item1.name} is no longer for sale.")
      within("#item-#{@item1.id}") do
        expect(page).to have_content("Not active")
      end
    end

    it "Inactive items will have an Activate link to activate that item." do
      within("#item-#{@item5.id}") do
        click_on "Activate"
      end
      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{@item5.name} is now available for sale.")
      within("#item-#{@item5.id}") do
        expect(page).to have_content("Active")
      end
    end

  end
end
