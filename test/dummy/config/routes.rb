Rails.application.routes.draw do
  
  #Right now we're only handling direct get|post|put|patch|delete calls passing in the plural resource
  # and single-line resources calls passing in the plural resource
  
  get '/people/index'
  get '/people/new' => 'people#new'
  get '/people/:id' => 'people#show'
  get '/people/:id/edit' => 'people#edit'
  post 'people/' => 'people#create'
  put 'people/:id' => 'people#update'
  delete 'people/(:id)' => 'people#destroy'
  
  resources :people
  
  
  #TODO: Nested resources rev 2
  # resources :comments do
  #   get 'preview', on: :new
  # end

  #Other possible formats
  #get 'person/:id' => 'people#show'
  #post 'post/:id' => 'people#create', as: "opt_name"
  #match 'photos', to: 'photos#show', via: [:get, :post]
  #match 'photos', to: 'photos#show', via: :all

  #Maybe rev 2???
  # scope '/admin' do
  #   resources :articles, :comments
  # end

  


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
