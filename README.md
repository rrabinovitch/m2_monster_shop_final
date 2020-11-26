# Monster Shop
"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will be able to get "shipped" by an admin. Each user role will have access to some or all CRUD functionality for application models.

This extenson was built off of a [group project](https://github.com/ajtran303/monster_shop_2005) of the same name, executed the week prior, and serves as the Module 2 final project for Turing School of Software & Design's Back-End Program. The extension implements a feature for merchant employees to set bulk discount rates for all of their inventory. Merchant employees have full CRUD functionality on bulk discounts. A discount is automatically applied when the quantity of a single item in a user's cart meets the minimum item quantity for accessing a discount. An order total takes into account any applied discounts on both the cart page and the order show page after an order has been checked out. If a merchant has multiple bulk discounts in the system, the discount that offers the best deal is ultimately applied.

This project offered a chance to implement and strengthen the knowledge and skills my original team and I have acquired so far this quarter (including MVC structure and conventions, routing, restful conventions, testing using RSpec and Capybara, etc.); and in particular, this was a chance to deepen our comfort with ActiveRecord calls, implement namespacing, authentication, and authorization for the first time.

## [Heroku site](https://mysterious-taiga-08229.herokuapp.com/)
### Seeded users
* regular user email: regular@email.com, password: "regular"
* merchant employee email: bike_employee@email.com, password: "employee"

## Implementation
Built with `ruby 2.5.3` and `Rails 5.1.7`
### Set up:
```bash
$ git clone git@github.com:rrabinovitch/m2_monster_shop_final.git
$ cd m2_monster_shop_final
$ bundle install
$ rake db:{drop,create,migrate,seed}
# run tests
$ bundle exec rspec
# explore the app on your local server
$ rails s
```
### In your browser, visit: `localhost:3000`
Now you're ready to rock and shop! Register as a new user, shop, and checkout!
### Adding different user roles in the command line
Certain features of the Monster Shop site require logging in as an `admin` or `merchant_employee`.
Create those users in the Rails Console:
#### In your terminal, run: `$ rails c`
```ruby
# create an admin
irb > User.create(name: "Admin", address: "123 Palm St", city: "Chicago", state: "IL", zip: 60623, email: "janedoe@email.com", password: "password", password_confirmation: "password", role: 2)
# create an employee for Meg's shop
irb > User.create(name: "Meg's employee", address: "123 Palm St", city: "Chicago", state: "IL", zip: 60623, email: "meg1@email.com", password: "password", password_confirmation: "password", role: 1, merchant_id: 1)
# create employees for Brians's shop
irb > User.create(name: "Brian's employee 1", address: "123 Palm St", city: "Chicago", state: "IL", zip: 60623, email: "brian1@email.com", password: "password", password_confirmation: "password", role: 1, merchant_id: 2)
irb > User.create(name: "Brian's employee 2", address: "123 Palm St", city: "Chicago", state: "IL", zip: 60623, email: "brian2@email.com", password: "password", password_confirmation: "password", role: 1, merchant_id: 2)
```
The keyboard command to exit `irb` is `ctrl + c`
### Log in as an admin or employees:
admin - janedoe@email.com - password

meg1 (merchant employee) - meg1@email.com - password

brian1 (merchant employee) - brian1@email.com - password

brian2 (merchant employee) - brian2@email.com - password

Log in as the appropriate user to use the feature described in a particular story.

## Learning Goals

### Rails
* Create routes for namespaced routes
* Implement partials to break a page into reusable components
* Use Sessions to store information about a user and implement login/logout functionality
* Use filters (e.g. `before_action`) in a Rails controller
* Limit functionality to authorized users
* Use BCrypt to hash user passwords before storing in the database

### ActiveRecord
* Use built-in ActiveRecord methods to join multiple tables of data, calculate statistics and build collections of data grouped by one or more attributes

### Databases
* Design and diagram a Database Schema
* Write raw SQL queries (as a debugging tool for AR)


## Design Notes
### User Roles
1. Visitor - this type of user is anonymously browsing our site and is not logged in
2. Regular User - this user is registered and logged in to the application while performing their work; can place items in a cart and create an order
3. Merchant Employee - this user works for a merchant. They can fulfill orders on behalf of their merchant. They also have the same permissions as a regular user (adding items to a cart and checking out)
4. Admin User - a registered user who has "superuser" access to all areas of the application; user is logged in to perform their work

User authentication and the authorization for different user roles to access different views and actions was developed using `bcrypt` and namespacing. For example, this controller is responsible for the actions that allow for the rendering of an admin user's dashboard. `:require_authorized_user` restricts access by regular users and merchant employees, and the `Admin::DashboardController` namespacing allows for the view to be accessed via an admin-specific path.
```ruby
class Admin::DashboardController < ApplicationController
  before_action :require_authorized_user

  def index
    @orders = Order.all
  end

  private

  def unauthorized_user?
    current_user.nil? || current_user.regular? || current_user.merchant_employee?
  end
end
```
An admin user's dashboard is rendered like this, when accessed by an admin user:
![admin dashboard](https://user-images.githubusercontent.com/62635544/88979822-a63e4600-d27f-11ea-950e-05c93711ee08.png)
But when an unauthorized user tries to access this admin-specific path, a 404 error message is displayed:
![404 error message view](https://user-images.githubusercontent.com/62635544/88979690-69724f00-d27f-11ea-8428-87ed0b95523b.png)

### Order Status
1. 'pending' means a user has placed items in a cart and "checked out" to create an order, merchants may or may not have fulfilled any items yet
2. 'packaged' means all merchants have fulfilled their items for the order, and has been packaged and ready to ship
3. 'shipped' means an admin has 'shipped' a package and can no longer be cancelled by a user
4. 'cancelled' - only 'pending' and 'packaged' orders can be cancelled

Enums were used for not only the user role attribute/column, but also to assign order status values. This allowed for use of methods that are made available via the implementation of enums. The following snippet demonstrates the use of an enum method within the presentation conditional logic found in the admin view of the orders index (AKA the admin dashboard):
```html
<h1>All Orders in System</h1>
  <% @orders.sort_by_status.each do |order| %>
    <section id="order-<%=order.id%>">
      <h3>Order #<%= order.id %></h3>
      <p>Customer: <%= link_to "#{order.user.name}", "/admin/users/#{order.user.id}" %></p>
      <p>Order placed on: <%= order.created_at %></p>
      <p>Order status: <%= order.status %></p>
      <% if order.packaged? %>
        <%= button_to "Ship", "admin/#{order.id}", method: :patch %>
      <% end %>
    </section>
  <% end %>
```
A user's view of their placed orders, displaying each order's status based on the enum value assigned to each order's status attribute:
![order status](https://user-images.githubusercontent.com/62635544/88979800-9d4d7480-d27f-11ea-96b5-3c0dfe2e9178.png)
