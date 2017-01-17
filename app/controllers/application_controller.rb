class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_company_layout
  before_action :util
  #Parámetros para el registro de usuarios con username y otros datos en devise
  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :name,
                   :telefono, :remember_me, :rol_ids]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  #Respuesta a la excepción lanzada por cancan cuando no hay autorización
  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  def set_company_layout
    if view_context.current_page?(root_path)
      session[:selected_company] = nil
    elsif !params[:company] && session[:selected_company].nil? && user_signed_in?
      puts controller_name
      new_session = devise_controller? || controller_name == "static_pages"
      redirect_to root_path if !new_session
    else
      choose = params[:company] == "true" ? true : false
      session[:selected_company] ||= choose
    end
  end

  def util
    util = Util.new
  end
end
