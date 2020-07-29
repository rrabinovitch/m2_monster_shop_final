require 'rails_helper'

RSpec.describe "Admin's Merchant Index Page"  do
  before(:each) do
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
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

  end

end
