class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  def subtotal
    price * quantity
  end

  def self.item_order_subtotal(order)
    select_items_in_order(order).sum('price * quantity')
  end

  def self.items_in_order_quantity(order)
    select_items_in_order(order).sum(:quantity)
  end

  def self.select_items_in_order(order)
    where({order_id: order.id})
  end
end
