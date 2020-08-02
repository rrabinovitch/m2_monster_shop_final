require 'rails_helper'

describe Discount, type: :model do
  describe "validations" do
    it { should validate_presence_of :percentage }
    it { should validate_presence_of :minimum_item_quantity }
  end

  describe "relationships" do
    it {should belong_to :merchant}
  end
end
