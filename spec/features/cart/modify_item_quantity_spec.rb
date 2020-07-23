require "rails_helper"

RSpec.describe "Cart show" do
  describe "As a visitor, when I have items in my cart" do
    describe "and visit my cart path" do

      before :each do
        @item = create(:item, name: "Magic Shoes", inventory: 3)
        @increment_button = "Add 1 #{@item.name}"
        @decrement_button = "Remove 1 #{@item.name}"

        visit "/items/#{@item.id}"
        click_on "Add To Cart"
        visit cart_path
      end

      describe "Add Item Quantity to Cart" do
        it "I can click a button to increment the count of items I want to purchase" do
          within "#cart-item-#{@item.id}" do
            expect(page).to have_content("1")
            expect(page).to have_button(@increment_button)

            click_on @increment_button
            expect(current_path).to eq(cart_path)
            expect(page).to have_content("2")
          end

        end

        it "I cannot increment the count beyond the item's inventory size" do
          within "#cart-item-#{@item.id}" do
            expect(page).to have_content("1")

            click_on @increment_button
            expect(page).to have_content("2")

            click_on @increment_button
            expect(page).to have_content("3")

            expect(page).to_not have_button(@increment_button)
          end
        end
      end

      describe "Decreasing Item Quantity from Cart" do
        it "I can click a button to decrement the count of items I want to purchase" do
          within "#cart-item-#{@item.id}" do
            click_on @increment_button
            expect(page).to have_content("2")

            expect(page).to have_button(@decrement_button)

            click_on @decrement_button
            expect(current_path).to eq(cart_path)
            expect(page).to have_content("1")
          end

        end

        it "If I decrement the count to 0 the item is immediately removed from my cart" do
          within "#cart-item-#{@item.id}" do
            expect(page).to have_button(@decrement_button)
            expect(page).to have_content("1")
            click_on @decrement_button
          end

          expect(current_path).to eq(cart_path)
          expect(page).to_not have_css("#cart-item-#{@item.id}")
        end
      end
    end
  end
end
