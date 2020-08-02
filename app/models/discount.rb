class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :percentage, :minimum_item_quantity
  validates :percentage, :numericality => { :greater_than => 0 }
  validates :minimum_item_quantity, :numericality => { :greater_than => 0 }
end
