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
    expect(page).to have_selector("input[value='#{user.email}']")
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
    expect(page).to have_content("Email Address: #{user.email}")
  end

  it "I can't edit my email address to one that belongs to another user" do
    user_1 = create(:user)
    user_2 = create(:user)
    updated_address = "123 Updated St"
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)

    visit '/profile/edit'

    fill_in :email, with: user_2.email
    fill_in :password, with: user_1.password
    click_on 'Update Profile'

    expect(page).to have_content("Email has already been taken")
    expect(current_path).to eq('/profile/edit')

  end

  it "I can edit my password" do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/profile'

    click_on "Change My Password"
    expect(current_path).to eq('/profile/password/edit')
    fill_in :password, with: "newpass"
    fill_in :confirm_password, with: "newpass"
    click_on "Save New Password"

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Your password has been changed.")
  end

  it "I can't edit my password if my input in 'password' is not the same as the input in 'confirm password'" do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/profile/password/edit'

    fill_in :password, with: "newpass"
    fill_in :confirm_password, with: "not_the_password"
    click_on "Save New Password"

    expect(page).to have_content("Passwords do not match")
    expect(current_path).to eq('/profile/password/edit')
  end
end
