class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity, :status

  belongs_to :item
  belongs_to :order

  enum status: [:unfulfilled, :fulfilled]

  def subtotal
    price * quantity if best_discount_rate.nil?
    apply_discount
  end

  def available_discounts
    item.merchant.discounts.where('minimum_item_quantity <= ?', quantity)
  end

  def best_discount_rate
    available_discounts.maximum(:percentage)
  end

  def apply_discount
    discount_calculation = (100 - best_discount_rate.to_f)/100
    (item.price * quantity) * discount_calculation
  end

  def fulfill
    item.sell(quantity)
    update(status: "fulfilled")
    order.pack if order.can_pack?
  end

  def unfulfill
    item.restock(quantity)
    update(status: "unfulfilled")
  end

  def can_fulfill?
    item.inventory >= self.quantity
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

  def self.all_subtotal
    sum{ |item_order| item_order.subtotal }
  end

  def self.pending_orders
    joins(:order).select('orders.*').where(orders: {status: "1"}).distinct
  end
end
