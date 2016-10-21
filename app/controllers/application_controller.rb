class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :rol_user
  before_action :selected_company_global
  
  #Parámetros para el registro de usuarios con username y otros datos en devise
  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :name,
    :telefono, :remember_me, :rol_ids]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
  
  #Respuesta a la excepción lanzada por cancan cuando no hay autorización
  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout =>false
  end
  
  # Método con gon para poder usar el rol desde los coffeescripts
  def rol_user
    if user_signed_in?
      gon.rol_user = current_user.has_rol? :gerente
      @rol_form = nil
      rol = current_user.roles
      (rol).each do |s|
        @rol_form = s.name
      end
    end
  end

  # Determina que empresa es con la que va a funcionar el sistema
  def selected_company_global
    if user_signed_in?
      if params[:company] == "true" || params[:company] == "false"
        session[:selected_company] = params[:company]=="true" ? true : false
      end
      if session[:selected_company].nil?
        respond_to do |format|
          format.html {render "static_pages/home"}
        end
      end
    end
  end
end
