require 'rails_helper'

RSpec.describe "Admin's Merchant Index Page"  do
  before(:each) do
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Los Angeles', state: 'CA', zip: 91436, enabled?: false)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Colorado Springs', state: 'CO', zip: 80913, enabled?: false)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
  end

  it "Displays a 'disable'/'enable' button next to the merchant and generates the corresponding flash message" do
    visit "/admin/merchants"
    within ".merchant-#{@brian.id}" do
      click_on "DISABLE"
      expect(current_path).to eq("/admin/merchants")
      expect(page).to_not have_link("DISABLE")
      expect(page).to have_link("ENABLE")
    end
    expect(page).to have_content("You have now disabled #{@brian.name}")

    within ".merchant-#{@brian.id}" do
      click_on "ENABLE"
      expect(current_path).to eq("/admin/merchants")
      expect(page).to_not have_link("ENABLE")
      expect(page).to have_link("DISABLE")
    end
    expect(page).to have_content("You have now enabled #{@brian.name}")
    save_and_open_page
  end

  it "After clicking 'disable'/'enable' on a merchant, the merchant's items are deactivated/activated" do
    expect(Merchant.find(@brian.id).items.all?(&:active?)).to be_truthy

    visit "/admin/merchants"
    within ".merchant-#{@brian.id}" do
      click_on "DISABLE"
    end

    expect(Merchant.find(@brian.id).items.all?(&:active?)).to be_falsey

    within ".merchant-#{@brian.id}" do
      click_on "ENABLE"
    end

    expect(Merchant.find(@brian.id).items.all?(&:active?)).to be_truthy
  end

  it "All merchants in the system are displayed, each listing their city and state with disable/enable buttons displayed according to 'enabled?' status" do
    visit "/admin/merchants"
    within ".merchant-#{@brian.id}" do
      expect(page).to have_content("City: #{@brian.city}")
      expect(page).to have_content("State: #{@brian.state}")
      expect(page).to have_link("DISABLE")
    end
    within ".merchant-#{@mike.id}" do
      expect(page).to have_content("City: #{@mike.city}")
      expect(page).to have_content("State: #{@mike.state}")
      expect(page).to have_link("ENABLE")
    end
    within ".merchant-#{@meg.id}" do
      expect(page).to have_content("City: #{@meg.city}")
      expect(page).to have_content("State: #{@meg.state}")
      expect(page).to have_link("ENABLE")
    end
  end

  it "A merchant's name links to their merchant dashboard" do
    visit "/admin/merchants"
    within ".merchant-#{@brian.id}" do
      click_on "#{@brian.name}"
    end
    expect(current_path).to eq("/admin/merchants/#{@brian.id}")
  end
end
