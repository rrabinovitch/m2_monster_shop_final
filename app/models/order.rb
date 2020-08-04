class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  enum status: [:packaged, :pending, :shipped, :cancelled]

  def grandtotal
    grandtotal = 0
    item_orders.each do |item_order|
      if item_order.item.merchant.discounts.empty?
        grandtotal = item_orders.sum('price * quantity')
      else
        if item_order.quantity >= item_order.item.merchant.discounts.first.minimum_item_quantity
          grandtotal += (item_order.price * item_order.quantity) * ((100 - item_order.item.merchant.discounts.first.percentage.to_f)/100)
        else
          grandtotal = item_orders.sum('price * quantity')
        end
      end
    end
    grandtotal
    # figure out a way for lines 14 and 19 to be calculated in those cases without needing to iterate
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
