module ActiveRecord
  module Acts
    module ShoppingCart
      module Collection
        #
        # Adds a product to the cart
        #
        def add(object, price, quantity = 1, share_qty = 0,share_price = 0,cumulative = true)
          cart_item = item_for(object)

          if cart_item
            cumulative = cumulative == true ? cart_item.quantity : 0
            cart_item.quantity = (cumulative + quantity)
            cart_item.save
            cart_item
          else
            shopping_cart_items.create(item: object, price: price, quantity: quantity,share_qty:share_qty,share_price:share_price)
          end
        end

        #
        # Deletes all shopping_cart_items in the shopping_cart
        #
        def clear
          shopping_cart_items.clear
        end

        #
        # Returns true when the cart is empty
        #
        def empty?
          shopping_cart_items.empty?
        end

        #
        # Remove an item from the cart
        #
        def remove(object, quantity = 1)
          if cart_item = item_for(object)
            if cart_item.quantity <= quantity
              cart_item.delete
            else
              cart_item.quantity = (cart_item.quantity - quantity)
              cart_item.save
            end
          end
        end

        #
        # Returns the subtotal by summing the price times quantity for all the
        # items in the cart
        #
        def subtotal
          sum = 0
           shopping_cart_items.each do |item| 
              sum+= (item.price * item.quantity)
           end
           sum
          #shopping_cart_items.inject(Money.new(0)) { |sum, item| sum += (item.price * item.quantity) }
        end

        def share_total
          sum = 0
           shopping_cart_items.each do |item| 
              sum+= (item.share_price * item.share_qty)
           end
           sum
            # .inject(Money.new(0)) { |sum, item| sum += (item.share_price * item.share_qty) }

        end

        def shipping_cost
          Money.new(0)
        end

        def taxes
          subtotal
        end

        def tax_pct
          8.25
        end

        #
        # Returns the total by summing the subtotal, taxes and shipping_cost
        #
        def total
          #self.subtotal + self.taxes + self.shipping_cost
          self.subtotal 
        end

        #
        # Return the number of unique items in the cart
        #
        def total_unique_items
          shopping_cart_items.inject(0) { |sum, item| sum += item.quantity }
        end

        def cart_items
          warn "ShoppingCart#cart_items WILL BE DEPRECATED IN LATER VERSIONS OF acts_as_shopping_cart, please use ShoppingCart#shopping_cart_items instead"
          self.shopping_cart_items
        end
      end
    end
  end
end
