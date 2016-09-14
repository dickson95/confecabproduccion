class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :rol_user
  #Parámetros para el registro de usuarios con username y otros datos en devise
  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :name,
    :telefono, :remember_me, :rol_ids => [] ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
  
  #Respuesta a la excepción lanzada por cancan cuando no hay autorización
  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout =>false
  end
  
  # Método con gon para poder usar el rol desde los coffeescripts
  def rol_user
    if !current_user.nil?
      gon.rol_user = current_user.has_rol? :gerente
    end
  end
end
