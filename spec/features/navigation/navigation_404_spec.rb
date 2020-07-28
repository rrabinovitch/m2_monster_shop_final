require "rails_helper"

RSpec.describe "Navigation 404 Spec" do

  before :all do
    @error_404 = "The page you were looking for doesn't exist."
  end

  describe "Visitor Navigation Restrictions" do
    describe "As a visitor, I see a 404 error when I try to access" do
      it "/merchant" do
        visit "/merchant"
        expect(page).to have_content(@error_404)

        visit merchant_dashboard_path
        expect(page).to have_content(@error_404)
      end

      it "/admin" do
        visit "/admin"
        expect(page).to have_content(@error_404)

        visit admin_dashboard_path
        expect(page).to have_content(@error_404)
      end

      it "/profile" do
        visit profile_path
        expect(page).to have_content(@error_404)
      end
    end
  end

  describe "Regular User Navigation Restrictions" do
    describe "As a default user, I see a 404 error when I try to access" do
      before :each do
        default_user = create(:user)
        visit login_path
        fill_in :email, with: default_user.email
        fill_in :password, with: default_user.password
        click_button 'Log In'
        expect(default_user.regular?).to be_truthy
      end

      it "/merchant" do
        visit "/merchant"
        expect(page).to have_content(@error_404)

        visit merchant_dashboard_path
        expect(page).to have_content(@error_404)
      end

      it "/admin" do
        visit "/admin"
        expect(page).to have_content(@error_404)

        visit admin_dashboard_path
        expect(page).to have_content(@error_404)
      end
    end
  end

  describe "Merchant Navigation Restrictions" do
    describe "As a merchant employee, I see a 404 error when I try to access" do
      before :each do
        merchant = create(:merchant)
        merchant_employee = create(:user, role: 1, merchant: merchant)
        visit login_path
        fill_in :email, with: merchant_employee.email
        fill_in :password, with: merchant_employee.password
        click_button 'Log In'
        expect(merchant_employee.merchant_employee?).to be_truthy
      end

      it "/admin" do
        visit "/admin"
        expect(page).to have_content(@error_404)

        visit admin_dashboard_path
        expect(page).to have_content(@error_404)
      end
    end
  end

  describe "Admin Navigation Restrictions" do
    describe "As an admin, I see a 404 error when I try to access" do
      before :each do
        admin_user = create(:user, role: 2)
        visit login_path
        fill_in :email, with: admin_user.email
        fill_in :password, with: admin_user.password
        click_button 'Log In'
        expect(admin_user.admin?).to be_truthy
      end

      it "/merchant" do
        visit "/merchant"
        expect(page).to have_content(@error_404)

        visit merchant_dashboard_path
        expect(page).to have_content(@error_404)
      end

      it "/cart" do
        visit cart_path
        expect(page).to have_content(@error_404)
      end
    end
  end
end
