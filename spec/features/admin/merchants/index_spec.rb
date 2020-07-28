require 'rails_helper'

RSpec.describe "Admin's Merchant Index Page"  do
  before(:each) do
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
  end

  it "Displays a 'disable' button next to any merchants who are not disabled and when the button is clicked, admin is returned to admin's merchant index page where there's a flash message that the merchant's account is now disabled" do
    visit "/admin/merchants"
    within ".merchant-#{@bike_shop.id}" do
      click_on "DISABLE"
      expect(current_path).to eq("/admin/merchants")
      expect(page).to_not have_link("DISABLE")
    end
    expect(page).to have_content("You have now disabled #{@bike_shop.name}")
  end
end

# User Story 38, Admin disables a merchant account
#
# As an admin
# When I visit the admin's merchant index page ('/admin/merchants')
# I see a "disable" button next to any merchants who are not yet disabled
# When I click on the "disable" button
# I am returned to the admin's merchant index page where I see that the merchant's account is now disabled
# And I see a flash message that the merchant's account is now disabled

# User Story 39, Disabled Merchant Item's are inactive
#
# As an admin
# When I visit the merchant index page
# And I click on the "disable" button for an enabled merchant
# Then all of that merchant's items should be deactivated
