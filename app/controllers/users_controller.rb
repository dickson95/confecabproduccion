class UsersController < ApplicationController
  before_filter :authorize_admin, only: :create
  before_action :set_user, only: [:only, :show]
  def index
    @users = User.all
    @id_user = current_user.id
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
  
    respond_to do |wants|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        wants.html { redirect_to(@user) }
        wants.json  { render :json => @user, :status => :created, :location => @user }
      else
        wants.html { render :action => "new" }
        wants.json  { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    
    if @user.destroy
  
      respond_to do |format|
        format.html { redirect_to users_path, notice: 'Usuario eliminado.' }
        format.json  { head :no_content }
      end
    end
  end
  
  private
   
    def authorize_admin
      return unless !current_user.has_rol? :admin
      redirect_to root_path, alert: '¡Sólo administradores!'
    end
  
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :name,
      :telefono, :remember_me, :rol_ids => [] )
    end
    
    def set_user
      @user = User.find(params[:id])
    end
end
