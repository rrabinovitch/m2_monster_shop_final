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
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  # def discounted_total
  #   discounted_total = 0
  #   items.each do |item, quantity|
  #     if item.merchant.discounts.empty?
  #       discounted_total += (item.price * quantity)
  #     else
  #       if quantity >= item.merchant.discounts.first.minimum_item_quantity
  #         discounted_total += (item.price * quantity) * ((100 - item.merchant.discounts.first.percentage.to_f)/100)
  #       else
  #         discounted_total += (item.price * quantity)
  #       end
  #     end
  #   end
  #   discounted_total
  # end
end
