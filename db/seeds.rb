# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Discount.destroy_all
ItemOrder.destroy_all
Order.destroy_all
Review.destroy_all
User.destroy_all
Merchant.destroy_all
Item.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 40)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 30)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 15, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 20)
ball = dog_shop.items.create(name: "Ball", description: "Very chewy", price: 5, image: "https://unicphscat.blob.core.windows.net/images-prd/s2702801.png", inventory: 20)

#users
regular = User.create!(name: "Regular User", address: "123 Regular St.", city: "Regularton", state: "CO", zip: 80235, email: "regular@email.com", password: "regular", role: 0)
bike_shop_employee = User.create!(name: "BikeShop Employee", address: "2234 Bike Ave.", city: "Bike City", state: "CO", zip: 82632, email: "bike_employee@email.com", password: "employee", role: 1, merchant_id: bike_shop.id)
