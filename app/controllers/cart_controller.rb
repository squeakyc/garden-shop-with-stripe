class CartController < ApplicationController
  before_action :authenticate_user!, except: [:add_to_cart, :view_order]
  # instead of except, you could also use only: [:checkout]


  def add_to_cart
    #create an order earlier using our helper method
    @order = current_order
    # get all the items from our line_item table
    line_item = @order.line_items.find_by(product_id: params[:product_id])

    #check to see if product already exists in our cart to prevent doubles
      if !line_item.blank?
         line_item.update(quantity: line_item.quantity += params[:quantity].to_i)
         line_item.update(line_item_total: line_item.quantity * line_item.product.price)

      else
        #if the item is already in the cart, update the quantity
        line_item = @order.line_items.new(product_id: params[:product_id], quantity: params[:quantity])


        line_item.update(line_item_total: (line_item.quantity * line_item.product.price))

      end

      @order.save
      session[:order_id] = @order.id

    redirect_back(fallback_location: root_path)
    # fallback is where to go if there is no "back" location, such as if the user opened a new tab to add to cart
  end

  def view_order
    @line_items = current_order.line_items
  end

  def checkout
    line_items = current_order.line_items
    unless line_items.length == 0
        current_order.update(user_id: current_user.id, subtotal: 0)

	      @order = current_order
        @order.user = current_user

        line_items.each do |line_item|
          line_item.product.update(quantity: (line_item.product.quantity - line_item.quantity))
          # need to figure out a way to keep inventory from going negative!
          @order.order_items[line_item.product_id] = line_item.quantity
          # hash - key is product id and value is line_item
          @order.subtotal += line_item.line_item_total
        end
        @order.save

        @order.update(sales_tax: (@order.subtotal * 0.08))
        @order.update(grand_total: (@order.sales_tax + @order.subtotal))
        session[:order_id] = nil
    end
  end

  def thank_you
    @order = Order.find(params[:order_id])

  end

  def order_complete
    @order = Order.find(params[:order_id])
    @amount = (@order.grand_total.to_f.round(2) * 100).to_i
    # stripe charges in cents, so that's why you multiply by 100 here

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :card => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer => customer.id,
      :amount => @amount,
      :description => 'Rails Stripe customer',
      :currency => 'usd'
    )

    redirect_to thank_you_path(order_id: @order.id)

    # in case there's a card error, it is saved as the letter e and a message is displayed & they are redirected back to the card
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to cart_path
  end
end
