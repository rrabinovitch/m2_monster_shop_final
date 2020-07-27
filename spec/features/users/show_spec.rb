require 'rails_helper'

RSpec.describe "When I visit my profile page as a registered user" do
  it "I see all my profile data (except my password), a link to edit my profile, and a link to edit my password" do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/profile'

    expect(page).to have_content("Name: #{user.name}")
    expect(page).to have_content("Street Address: #{user.address}")
    expect(page).to have_content("City: #{user.city}")
    expect(page).to have_content("State: #{user.state}")
    expect(page).to have_content("ZIP Code: #{user.zip}")
    expect(page).to have_content("Email Address: #{user.email}")
    expect(page).to have_link("Edit My Profile")
    expect(page).to have_link("Change My Password")
  end
end
