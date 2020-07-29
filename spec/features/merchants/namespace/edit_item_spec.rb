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

      @item1 = create(:item, merchant_id: @merchant.id, description: "it's ok")
      @item2 = create(:item, merchant_id: @merchant.id)
      @item3 = create(:item, merchant_id: @merchant.id)
      @order = create(:order)

      ItemOrder.create(item: @item2, order: @order, price: 5, quantity: 2)
      visit "/merchant/items"
    end

    it "I see a link to add a new item" do
      within("#item-#{@item1.id}") do
        expect(page).to have_link("Edit")
      end
    end

    it "clicking on a link takes me a form to fill out the information of the new item detail. Upon submitting the form, I am taken back to the items index page, and a message confirms the addition of the new item" do
      within("#item-#{@item1.id}") do
        click_on "Edit"
      end
      expect(current_path).to eq("/merchant/items/#{@item1.id}/edit")

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = 25

      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: 25

      click_button "Update Item"
      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("Item has been updated")

      within("#item-#{@item1.id}") do
        expect(page).to have_content("Name: #{name}")
        expect(page).to have_content("Description: #{description}")
        expect(page).to have_content("Price: #{price}")
        expect(page).to have_content("Image: #{image_url}")
        expect(page).to have_content("Active")
      end
    end

    it "Filling out the form incorrectly will return me to the form with all appropriate errors shown. All non-offending fields remain populated. Inventory cannot be less than zero." do
      within("#item-#{@item1.id}") do
        click_on "Edit"
      end
      expect(current_path).to eq("/merchant/items/#{@item1.id}/edit")

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = -5

      fill_in :name, with: ""
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_button "Update Item"

      expect(current_path).to eq("/merchant/items/#{@item1.id}")
      expect(page).to have_content("Inventory must be greater than or equal to 0")
      expect(page).to have_content("Name can't be blank")
      expect(page).to_not have_selector("input[value='#{name}']")
      expect(page).to have_selector("input[value='#{price}']")
      expect(page).to have_selector("input[value='#{description}']")
      expect(page).to have_selector("input[value='#{image_url}']")
      expect(page).to have_selector("input[value='#{inventory}']")
    end

    it "Price cannot be edited to be below zero." do
      within("#item-#{@item1.id}") do
        click_on "Edit"
      end
      expect(current_path).to eq("/merchant/items/#{@item1.id}/edit")

      name = "Chamois Buttr"
      price = -18
      description = "No more chaffin!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = 25

      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_button "Update Item"

      expect(current_path).to eq("/merchant/items/#{@item1.id}")
      expect(page).to have_content("Price must be greater than 0")
      expect(page).to have_selector("input[value='#{name}']")
      expect(page).to have_selector("input[value='#{price}']")
      expect(page).to have_selector("input[value='#{description}']")
      expect(page).to have_selector("input[value='#{image_url}']")
      expect(page).to have_selector("input[value='#{inventory}']")
    end

  end
end
