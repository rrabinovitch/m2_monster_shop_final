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
      expect(page).to have_link("Add Item")
    end

    it "clicking on a link takes me a form to fill out the information of the new item detail" do
      click_on "Add Item"
      expect(current_path).to eq("/merchant/items/new")

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = 25

      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_button "Create Item"

      new_item = Item.last

      expect(current_path).to eq("/merchant/items")
      expect(new_item.name).to eq(name)
      expect(new_item.price).to eq(price)
      expect(new_item.description).to eq(description)
      expect(new_item.image).to eq(image_url)
      expect(new_item.inventory).to eq(inventory)
      expect(Item.last.active?).to be(true)

      expect(page).to have_content("Added #{new_item.name} to item list")
      within("#item-#{new_item.id}") do
        expect(page).to have_content("Name: #{new_item.name}")
        expect(page).to have_content("Description: #{new_item.description}")
        expect(page).to have_content("Price: #{new_item.price}")
        expect(page).to have_content("Image: #{new_item.image}")
        expect(page).to have_content("Active")
      end
    end

    it "upon submitting the form, I am taken back to the items index page, and a message confirms the addition of the new item" do

    end
  end
end
