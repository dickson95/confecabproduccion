Rails.application.routes.draw do
  resources :tallas
  root :to => 'lotes#index'
  resources :roles
  devise_for :users
  resources :users, except: :create
  post 'users/create_user' => 'users#create', as: :create_user
  resources :programaciones
  resources :control_lotes
  get "lotes/add_remote_data" => 'lotes#add_remote_data', :as => :add_remote_data
  get "lotes/view_datails/:id" => 'lotes#view_datails', :as => :view_datails
  resources :lotes do
    get :autocomplete_color_color, :on => :collection
  end
    get 'lotes/cambio_estado/:id', 
    to: 'lotes#cambio_estado', as: 'cambio_estado'
  resources :sub_estados
  get "clientes/send_email" => 'clientes#send_email', :as => :send_email
  resources :clientes
  resources :referencias 
  resources :estados
  resources :tipos_prendas
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
