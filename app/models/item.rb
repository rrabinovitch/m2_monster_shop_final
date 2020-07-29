class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory 

  validates :inventory, :numericality => { :greater_than_or_equal_to => 0}
  validates_inclusion_of :active?, :in => [true, false]
  scope :active_items, -> {where(active?: true)}
  scope :join_with_item_orders, -> { joins(:item_orders) }
  scope :group_by_quantity, -> { select("items.*, sum(quantity) as order_quantity").group(:id) }

  validates_numericality_of :price, greater_than: 0

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def total_sold
    item_orders.sum(:quantity)
  end

  def self.most_popular_list
    join_with_item_orders.group_by_quantity.order("order_quantity DESC").limit(5)
  end

  def self.least_popular_list
    join_with_item_orders.group_by_quantity.order("order_quantity").limit(5)
  end
end
