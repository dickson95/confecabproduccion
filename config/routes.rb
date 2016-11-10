Rails.application.routes.draw do
  get '/pages', to: 'static_pages#home', as: :home
  # Inicio de la aplicación
  root :to => 'static_pages#home'
  
  # Rutas para las programaciones
  # Pasar todas las programaciones como parte del recurso de las rutas
  # Esto implica reestructurar toda la forma como envío los datos al cliente ya que debo imprimir una lisa
  # de programaciones y tener el :id de cada una. Ademas cada que se cambie entre las pestañas hay que
  # cambiar la url para que coincida con el mes que le corresponde
  match 'programaciones/remove_from_programing/:month', to: 'programaciones#remove_from_programing', as: :remove_from_programing, via: [:post, :patch] # Para editar un atributo concreto; es patch
  get 'programaciones/program_table/:month', to: 'programaciones#program_table', as: :program_table
  get 'programaciones/modal_open/:month', to: 'programaciones#modal_open', as: :modal_open  # Leer recurso; es get
  resources :programaciones, only:[:index] do 
    # Más información sobre collection http://guides.rubyonrails.org/routing.html#adding-collection-routes
    get :export_pdf, on: :collection
    get :export_excel, on: :collection
    patch :generate, on: :member # Editar una parte concreta, es patch
    patch :add_lotes_to_programing, as: :add_lotes, on: :collection # Para editar un atributo concreto; es patch
    post 'update_row_order', on: :collection 
  end


  # Rutas de los usuarios
  devise_for :users
  resources :users, except: [:create] do 
    post 'new' => 'users#create', as: :create, on: :collection
  end
  
  resources :lotes do
    get :autocomplete_color_color, :on => :collection
    get :view_details # es método get, y parte de los lotes
    patch :cambio_estado # Este es patch y debe pertenecer a los lotes
    patch :total_price # esta es un patch y pertenece a los lotes
    resources :control_lotes
  end

  # Otras rutas
  resources :sub_estados
  # get "clientes/send_email" => 'clientes#send_email', :as => :send_email # debe pertenecer a los clientes y tener el id del cliente a quien se envía el correo
  resources :clientes
  resources :referencias 
  resources :tipos_prendas
  resources :tallas
  resources :roles
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # http://guides.rubyonrails.org/routing.html#non-resourceful-routes
end
