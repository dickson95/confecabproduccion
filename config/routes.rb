Rails.application.routes.draw do
  get '/pages', to: 'static_pages#home', as: :home
  # Inicio de la aplicación
  root :to => 'static_pages#home'
  
  # Rutas para las programaciones

  post 'programaciones/program_table/:month', to: 'programaciones#program_table', as: :program_table
  post 'programaciones/generate_program/:id', to: 'programaciones#generate_program', as: :generate
  post 'programaciones/add_lotes_to_program', to: 'programaciones#add_lotes_to_programing', as: :add_lotes_programing
  post 'programaciones/remove_from_programing/:month', to: 'programaciones#remove_from_programing', as: :remove_from_programing
  get 'programaciones/export_excel', to: 'programaciones#export_excel', as: :export_excel
  get 'programaciones/export_pdf', to: 'programaciones#export_pdf', as: :export_pdf
  get 'programaciones/modal_open/:month', to: 'programaciones#modal_open', as: :modal_open
  resources :programaciones, only:[:index] do 
    post 'update_row_order', on: :collection
  end


  # Rutas de los usuarios
  devise_for :users
  resources :users, except: :create
  post 'users/new' => 'users#create', as: :create_user
  
  
  # Rutas de los lotes
  post 'lotes/:id/total_price' => 'lotes#total_price', :as => :lote_total_price
  get "lotes/add_remote_data" => 'lotes#add_remote_data', :as => :add_remote_data
  resources :lotes do
    get :autocomplete_color_color, :on => :collection
    get :view_datails
    resources :control_lotes
  end
  
  get 'lotes/cambio_estado/:id', 
    to: 'lotes#cambio_estado', as: 'cambio_estado'

  # Otras rutas
  resources :sub_estados
  get "clientes/send_email" => 'clientes#send_email', :as => :send_email
  resources :clientes
  resources :referencias 
  resources :tipos_prendas
  resources :tallas
  resources :roles
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
