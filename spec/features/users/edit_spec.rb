require 'rails_helper'

RSpec.describe 'When I visit my profile page as a registered user' do
  it "I can click a link to edit my profile data and I am redirected to a form prepopulated with my current information except my password" do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/profile'

    click_on "Edit My Profile"
    expect(current_path).to eq('/profile/edit')
    expect(page).to have_selector("input[value='#{user.name}']")
    expect(page).to have_selector("input[value='#{user.address}']")
    expect(page).to have_selector("input[value='#{user.city}']")
    expect(page).to have_selector("input[value='#{user.state}']")
    expect(page).to have_selector("input[value='#{user.zip}']")
  end

  it "When I change any or all of my information and I submit the edit form, I am returned to my profile page, where I see my updated information and a flash message confirming the update" do
    user = create(:user)
    updated_address = "123 Updated St"
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/profile/edit'

    fill_in :address, with: updated_address

    click_on 'Update Profile'

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Your profile data has been updated.")
    expect(page).to have_content("Name: #{user.name}")
    expect(page).to have_content("Street Address: #{updated_address}")
    expect(page).to have_content("City: #{user.city}")
    expect(page).to have_content("State: #{user.state}")
    expect(page).to have_content("ZIP Code: #{user.zip}")
  end
end
