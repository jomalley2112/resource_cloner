Rails.application.routes.draw do

    
  
############ Keep stuff after this line ###########
  
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
  resource  :person
  
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

  
end
