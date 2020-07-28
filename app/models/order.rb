class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  enum status: [:packaged, :pending, :shipped, :cancelled]

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def cancel
    self.item_orders.each do |item_order|
      item_order.unfulfill if item_order.fulfilled?
    end
    self.update(status: "cancelled")
  end

  def method_name

  end
end
