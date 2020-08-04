class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  enum status: [:packaged, :pending, :shipped, :cancelled]

  def grandtotal
    item_orders.sum do |item_order|
      item_order.subtotal
    end
  end

  def cancel
    self.item_orders.each do |item_order|
      item_order.unfulfill if item_order.fulfilled?
    end
    self.update(status: "cancelled")
  end

  def self.sort_by_status
    order(:status)
  end

  def merchant_items(merchant)
    item_orders.where({item_id: merchant.item_orders.pluck(:item_id)})
  end

  def can_pack?
    item_orders.all?(&:fulfilled?)
  end

  def pack
    self.update(status: "packaged") if can_pack?
  end
end
