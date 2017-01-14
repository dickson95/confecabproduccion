=begin
CONTROLADOR DE USUARIOS (USERS)
Controlador independente del que devise usa para abrir sessions registrar usuarios y demás acciones. Esta clase
es para uso del administrador del sistema de modo que pueda gestionar los usuarios
=end
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy, :update]
  

  # Validación de autorización
  load_and_authorize_resource
  def index
    respond_to do |format|
      format.html
      format.json {render json: users_json}
    end
  end

  def new
    @user = User.new
  end
  
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        flash[:success] = 'Usuario registrado con éxito.'
        format.html { redirect_to users_path }
        format.json  { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    if @user.id != 1
      if @user.destroy
        respond_to do |format|
          format.json  { head :no_content }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to users_path }
        flash[:danger] = "Este usuario no puede ser eliminado"
        format.json { head :conflict }
      end
    end
  end
  
  def edit
    respond_to do |format|
      format.js {render "show"}
    end
  end

  def update
    roles_user = RolesUser
    @rol = roles_user.where(:user_id => @user.id).update(:rol_id => params[:user][:rol_ids])
    if @rol
      @new_rol = roles_user.joins(:rol)
                  .where(user_id: params[:id])
                  .pluck("roles.name")
      respond_to do |format|
        format.js {render "show"}
      end
    end
  end

  # Bloquear los usuarios
  def lock
    user = User.find(params[:id])
    user.lock_access!(send_instructions: false)
    response_json(json: {message: "Usuario #{user.name} bloqueado. Ya no podrá acceder al sistema"})
  end

  # Desbloquear los usuarios
  def unlock
    user = User.find(params[:id])
    user.unlock_access!
    response_json(json: {message: "Usuario #{user.name} desbloqueado. Ya puede acceder al sistema"})
  end

  private

  def users_json
    lock = params[:lock?]
    @lock = true if lock == "true"
    @users = User.where("locked_at #{(@lock ? "IS NOT NULL" : "IS NULL")}")
    view_context.render(partial: "table", formats: :html)
  end

  # Respuesta con json
  def response_json(options)
    respond_to do |format|
      format.json{render options}
    end
  end

    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :name,
        :telefono, :remember_me, :rol_ids )
    end

    def set_user
      @user = User.find(params[:id])
    end
end
