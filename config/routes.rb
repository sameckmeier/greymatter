Rails.application.routes.draw do

  #DEFAULT
  root 'static_pages#landing'

  #SESSIONS
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"
  resources :users

  #SEARCHES
  get "/:q" , to: "searches#show", constraints: {q: /[.]+/}

  #ARTISTS
  #get "/artist/:name" , to: "artists#show", constraints: {name: /[.]+/}
  get 'artist/:name' => 'artists#show'

  #ALBUMS
  #get "/artist/:artist_name/album/:album_name" , to: "albums#show", constraints: {artist_name: /[.]+/, album_name: /[.]+/}
  get 'artist/:artist_name/album/:album_name' => 'albums#show'

  #HOME PAGE
  get '/home' => 'static_pages#home'

  #HELP PAGE
  get '/help' => 'static_pages#help'

  #ASYNC REQUESTS
  get '/typeahead-search/:q' => 'async#typeahead_search'
  get '/current-user-dropdown' => 'async#current_user_menu'
  get '/current-user-notifications' => 'async#current_user_notifications'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
