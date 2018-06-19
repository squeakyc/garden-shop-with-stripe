Rails.application.routes.draw do
  devise_for :users

  # cart controller
  post 'add_to_cart' => 'cart#add_to_cart'
  post 'order_complete' =>'cart#order_complete'
  get 'thank_you' => 'cart#thank_you'
  get 'view_order' => 'cart#view_order'
  get 'checkout' => 'cart#checkout'

  # storefront controller
  root 'storefront#all_items'
  get 'categorical' => 'storefront#items_by_category'
  get 'branding' => 'storefront#items_by_brand'

  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end
