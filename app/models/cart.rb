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
    item.price * @contents[item.id.to_s] if best_discount_rate(item).nil?
    apply_discount(item)
  end

  def total
    items.sum do |item, _quantity|
      subtotal(item)
    end
  end

  def available_discounts(item)
    quantity = @contents[item.id.to_s]
    item.merchant.discounts.where('minimum_item_quantity <= ?', quantity)
  end

  def best_discount_rate(item)
    available_discounts(item).maximum(:percentage)
  end

  def apply_discount(item)
    quantity = @contents[item.id.to_s]
    discount_calculation = (100 - best_discount_rate(item).to_f)/100
    (item.price * quantity) * discount_calculation
  end
end
