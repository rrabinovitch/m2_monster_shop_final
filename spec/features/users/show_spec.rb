require 'rails_helper'

RSpec.describe "When I visit my profile page as a registered user" do
  it "I see all my profile data (except my password) and a link to edit my profile" do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/profile'

    expect(page).to have_content(user.name)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)
    expect(page).to have_link("Edit My Profile")
  end
end
