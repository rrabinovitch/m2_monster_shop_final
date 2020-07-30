require 'rails_helper'

RSpec.describe "Admin user profile page" do
  it "An admin sees the user type, when they registered their account, and the same information a user would see themselves (except profile edit links)" do
    @admin = create(:user, role: 2)
    @regular_user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    visit "/admin/users/#{@regular_user.id}"
    expect(page).to have_content("Viewing #{@regular_user.name}'s User Profile")
    expect(page).to have_content("User type: #{@regular_user.role}")
    expect(page).to have_content("Registered on: #{@regular_user.created_at}")
    expect(page).to have_content("Street Address: #{@regular_user.address}")
    expect(page).to have_content("City: #{@regular_user.city}")
    expect(page).to have_content("State: #{@regular_user.state}")
    expect(page).to have_content("ZIP Code: #{@regular_user.zip}")
    expect(page).to have_content("Email Address: #{@regular_user.email}")
  end
end
