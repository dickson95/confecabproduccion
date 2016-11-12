class ControlLotesController < ApplicationController
  #Solicitar prueba de permisos antes de cargar cualquier acción
  load_and_authorize_resource 
  before_action :set_lote
  before_action :set_control_lotes, only: [:edit, :update, :destroy]
  before_action :sub_estados, only: [:new, :edit]
  
  # GET /control_lotes
  # GET /control_lotes.json
  def index
    company = session[:selected_company]
    @ciclo_lote = @lote.control_lotes
    @sub_estado = {}
    @sub_estados = SubEstado.all.each{ |e|  @sub_estado[e.id] = e.sub_estado}
    @user = {}
    @users = User.select("id, name").each{ |e|  @user[e.id] = e.name}
    respond_to do |format|
      # En caso de que se acceda por la url directo se envía un mensaje indicando que hacer
      format.html{redirect_to lotes_path, notice: "Seleccione el ciclo de un lote" }
      format.js
    end
  end
  
  def new
    @control_lote = ControlLote.new
  end

  def create
    respond_to do |format|
      last_state_lote = @lote.control_lotes.last
      @control_lote = @lote.control_lotes.new(control_lote_params)
      if @control_lote.save
        last_state_lote.update(:resp_salida_id => current_user, 
          :fecha_salida => control_lote_params[:fecha_ingreso] )
        format.html { redirect_to lotes_path }
        flash[:success] = "Proceso nuevo registrado"
        format.json { render :index, status: :ok }
      else
        sub_estados
        format.html { render :new }
        format.json { render json: @control_lote.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update  
    respond_to do |format|
      if @control_lote.update(control_lote_params)
        format.html { redirect_to lotes_path }
        flash[:success] = "Proceso actualizado correctamente"
      else
        sub_estados
        format.html { render :edit }
        format.json { render json: @control_lote.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @control_lote.destroy
    respond_to do |format|
      format.html { redirect_to lotes_path }
      flash[:success] = "Proceso eliminado."
      format.json { head :no_content }
    end
  end

  private
    def control_lote_params
      params.require(:control_lote).permit(:fecha_ingreso, :estado_id, :sub_estado_id,
        :observaciones).merge(resp_ingreso_id: current_user)
    end

    def set_lote
      @lote = Lote.find(params[:lote_id])
      @control = @lote.control_lotes.last
    end

    def set_control_lotes
      @control_lote = @lote.control_lotes.find(params[:id])
    end

    def sub_estados
      @sub_estados = SubEstado.all
    end
end
