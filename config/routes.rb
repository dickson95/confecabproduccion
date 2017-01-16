Rails.application.routes.draw do

  get 'estadisticas', to: 'estadisticas#index'
  get "estadisticas/programaciones/detalles/:year/:month", to: "estadisticas#show_programaciones", as: :programaciones_show
  get "estadisticas/clientes/detalles/:year", to: "estadisticas#show_cliente", as: :clientes_show
  get "estadisticas/clientes/mes/:year_month", to: "estadisticas#show_month_cliente", as: :clientes_month_show
  namespace :estadisticas do
    get :clientes
    get :programaciones
  end

  # Rutas para las programaciones
  match 'programaciones/remove_from_programing/:month', to: 'programaciones#remove_from_programing', as: :remove_from_programing, via: [:post, :patch] # Para editar un atributo concreto; es patch
  get 'programaciones/program_table/:month', to: 'programaciones#program_table', as: :program_table
  get 'programaciones/modal_open/:month', to: 'programaciones#modal_open', as: :modal_open  # Leer recurso; es get
  get 'programaciones/options_export/:month', to: 'programaciones#options_export', as: :programacion_options_export
  resources :programaciones, only:[:index] do
    # Más información sobre collection http://guides.rubyonrails.org/routing.html#adding-collection-routes
    get :export_pdf, on: :collection
    get :export_excel, on: :member
    get :get_row, on: :collection
    patch :generate, on: :member # Editar una parte concreta, es patch
    patch :add_lotes_to_programing, as: :add_lotes, on: :collection # Para editar un atributo concreto; es patch
    patch :update_row_order, on: :collection
    post :update_meta_mensual
  end

  # Rutas de los usuarios
  devise_for :users
  resources :users, except: [:create] do
    post 'new' => 'users#create', as: :create, on: :collection
    patch :lock, on: :member
    patch :unlock, on: :member
  end

  # Rutas de los lotes
  resources :lotes do
    get :autocomplete_color_color, :on => :collection
    get :options_export, :on => :collection
    get :export_excel, :on => :collection
    get :view_details           # es método get, y parte de los lotes
    patch :cambio_estado        # Este es patch y debe pertenecer a los lotes
    patch :total_price, on: :member # esta es un patch y pertenece a los lotes
    patch :update_ingresara_a_planta, on: :member
    patch :update_programacion, on: :member
    resources :control_lotes do 
      patch :update_cantidad, on: :member
    end
    post :validate_op
  end

  resources :control_lotes do
    resources :seguimientos
  end

  # Otras rutas
  resources :sub_estados, :referencias, :tipos_prendas, :tallas, :roles, :clientes
  resources :calendario, except: :show
  resources :estados, only: [:index, :edit, :update]
  # get "clientes/send_email" => 'clientes#send_email', :as => :send_email # debe pertenecer a los clientes y tener el id del cliente a quien se envía el correo

  get '/sobre-confecab', to: 'static_pages#about_confecab', as: :about_confecab
  get '/sobre-disenos-y-camisas', to: 'static_pages#about_dyc', as: :about_dyc
  # Inicio de la aplicación
  root :to => 'static_pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # http://guides.rubyonrails.org/routing.html#non-resourceful-routes
end
