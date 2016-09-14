class UsersController < ApplicationController
  before_action :set_user, only: [:only, :show, :destroy]
  
  # Validación de autorización
  load_and_authorize_resource
  def index
    @users = User.all
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
        format.html { redirect_to(@user) }
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
          format.html { redirect_to users_path }
          flash[:success] = "Usuario eliminado correctamente"
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
  
  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :name,
      :telefono, :remember_me, :rol_ids => [] )
    end
    
    def set_user
      @user = User.find(params[:id])
    end
end
