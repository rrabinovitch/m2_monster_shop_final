class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity, :status

  belongs_to :item
  belongs_to :order

  enum status: [:unfulfilled, :fulfilled]

  def subtotal
    price * quantity
  end

  def fulfill
    item.sell(quantity)
    update(status: "fulfilled")
  end

  def unfulfill
    item.restock(quantity)
    update(status: "unfulfilled")
  end
end
