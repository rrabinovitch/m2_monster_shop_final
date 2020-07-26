class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  def subtotal
    price * quantity
  end

  def self.select_items_in_order(item)
    where({item_id: item.id})
  end

  def self.items_in_order_quantity(item)
    select_items_in_order(item).sum(:quantity)
  end

  def self.item_order_subtotal(item)
    items_in_order_quantity(item) * item.price
  end
end
