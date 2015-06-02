module ActiveRecord
  module Acts
    module ShoppingCartItem
      module InstanceMethods
        #
        # Returns the subtotal, multiplying the quantity times the price of the item.
        #
        def subtotal
          ("%.2f" % (self.quantity * self.price)).to_f
        end

        def share_total
          ("%.2f" % (self.share_qty * self.share_price)).to_f
        end

        #
        # Updates the quantity of the item
        #
        def update_quantity(new_quantity)
            self.quantity = new_quantity
            self.save
        end

        #
        # Updates the price of the item
        #
        def update_price(new_price)
            self.price = new_price
            self.save
        end
      end
    end
  end
end
