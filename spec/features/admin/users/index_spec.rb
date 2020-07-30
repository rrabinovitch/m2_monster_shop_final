require 'rails_helper'

RSpec.describe "Admin user index page" do
  before :each do
    @admin = create(:user, role: 2)
    @regular_user = create(:user)
    @merchant_employee = create(:user, role: 1)
    @error_404 = "The page you were looking for doesn't exist."
  end

  it "There is a users link in my nav that routes me to a users index page" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    visit "/"
    within('nav') do
      click_on "All Users"
    end
    expect(current_path).to eq("/admin/users")
    expect(page).to have_content(@regular_user.name)
    expect(page).to have_content(@merchant_employee.name)
    expect(page).to have_content(@admin.name)
  end

  it "Only admin users can access this users index page" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@customer)
    visit "/admin/users"
    expect(page).to have_content(@error_404)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    expect(page).to have_content(@error_404)
  end

  it "This page lists all users in the system, where a user's name links to their user show page,
      which displays the user's registration date and the type of user" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    visit "/admin/users"
    click_on "#{@regular_user.name}"
    expect(current_path).to eq("/admin/users/#{@regular_user.id}")
  end
end
