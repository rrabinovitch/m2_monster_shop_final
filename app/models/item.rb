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
  validates_inclusion_of :active?, :in => [true, false]
  scope :active_items, -> {where(active?: true)}
  #scope :total_quantity, ->
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

  def self.least_popular
    sorted_by_quantity.map {|item|  "#{item.name}: #{item.total_sold}"}[0..4]
  end

  def self.most_popular
    sorted_by_quantity.map {|item|  "#{item.name}: #{item.total_sold}"}[-5..-1].reverse
  end

  def total_sold
    item_orders.sum(:quantity)
  end

  private

  def self.sorted_by_quantity
    joins(:item_orders).select("items.*, sum(quantity) as order_quantity").group(:id).order("order_quantity")
  end
end
