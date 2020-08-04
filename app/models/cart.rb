class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def remove_item(item)
    @contents[item] -= 1
    @contents.delete(item) if @contents[item].zero?
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    quantity = @contents[item.id.to_s]
    discount = item.merchant.discounts.first
    if !item.merchant.discounts.empty? && quantity >= discount.minimum_item_quantity
      (item.price * quantity) * ((100 - discount.percentage.to_f) / 100)
    else
      item.price * quantity
    end
  end

  def total
    total = 0
    items.each do |item, quantity|
      if best_discount_rate(item).nil?
        total += (item.price * quantity)
      else
        total += apply_discount(item)
      end
    end
    total
    # total = 0
    # items.each do |item, quantity|
    #   if item.merchant.discounts.empty?
    #     total += (item.price * quantity)
    #   else
    #     if quantity >= item.merchant.discounts.first.minimum_item_quantity
    #       total += (item.price * quantity) * ((100 - item.merchant.discounts.first.percentage.to_f)/100)
    #     else
    #       total += (item.price * quantity)
    #     end
    #   end
    # end
    # total
    # @contents.sum do |item_id,quantity|
    #   Item.find(item_id).price * quantity
    # end
  end

  def available_discounts(item)
    quantity = @contents[item.id.to_s]
    item.merchant.discounts.where('minimum_item_quantity <= ?', quantity)

    # available_discounts = []
    # item.merchant.discounts.each do |discount|
    #   available_discounts << discount if quantity >= discount.minimum_item_quantity
    # end
    # available_discounts
  end

  def best_discount_rate(item)
    # available_discounts(item).order(percentage: :desc).first << come back to this if needing access to full discount record rather than just the percentage
    available_discounts(item).maximum(:percentage)
  end

  def apply_discount(item)
    quantity = @contents[item.id.to_s]
    discount_rate = (100 - best_discount_rate(item).to_f)/100
    (item.price * quantity) * discount_rate
  end
end
