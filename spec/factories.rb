placeholder_image = "https://www.webfx.com/blog/images/cdn.designinstruct.com/files/582-how-to-image-placeholders/generic-image-placeholder.png"

FactoryBot.define do
  factory :item do
    merchant
    sequence(:name) { |n| "Item #{n}" }
    description { "What a cool item!" }
    price { 100 }
    image { placeholder_image }
    active? { true }
    inventory { 12 }
  end

  factory :merchant do
    sequence(:name) { |n| "Merchant #{n}" }
    address { "22 Baker St" }
    city { "London" }
    state { "TX" }
    zip { 10000 }
  end

  factory :review do
    item
    sequence(:title) { |n| "Review #{n}"}
    content { "This was awesome!" }
    rating { 5 }
  end

  factory :order do
    sequence(:name) { |n| "Order #{n}" }
    address { "33 Buyers Square" }
    city { "Chicago" }
    state { "IL" }
    zip { 60000 }
  end

end
