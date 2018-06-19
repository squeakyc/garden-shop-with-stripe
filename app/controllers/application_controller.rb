class ApplicationController < ActionController::Base
  helper_method :current_order

  def current_order
    if !session[:order_id].nil?
      # session is a hash in rails. Here, if there is an an order id, we find it in the database & that is the current order. Otherwise it creates a new order.
      Order.find(session[:order_id])
    else
      Order.new(subtotal: 0)
    end
  end
end
