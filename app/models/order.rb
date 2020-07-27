class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  enum status: [:pending, :packaged, :shipped, :cancelled]

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def merchant_items(merchant)
    item_orders.where({item_id: merchant.item_orders.pluck(:item_id)})
  end
end
