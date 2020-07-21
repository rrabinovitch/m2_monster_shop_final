require "rails_helper"

RSpec.describe User do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_numericality_of(:zip) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:role) }
  end

  describe "roles" do
    it "can be created as a default regular user" do
      user = create(:user)

      expect(user.role).to eq("regular")
      expect(user.regular?).to be_truthy
    end

    it "can be created as a merchant employee" do
      user = create(:user, role: 1)

      expect(user.role).to eq("merchant_employee")
      expect(user.merchant_employee?).to be_truthy
    end

    it "can be created as an admin" do
      user = create(:user, role: 2)

      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
    end
  end
end
