class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users
  has_many :discounts

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip


  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def change_status
    if self.enabled?
      self.update(enabled?: "false")
    else
      self.update(enabled?: "true")
    end
  end

  def change_active_status
    items.each do |item|
      if item.active?
        item.update(active?: "false")
      else
        item.update(active?: "true")
      end
    end
  end

end
