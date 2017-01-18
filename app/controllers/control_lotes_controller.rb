=begin
  CONTROLADOR DE CONTROL LOTES
Todas las acciones a la vista de acuerdo con el paradigma MVC
Este controlador es dependiente del controlador de los lotes y representa el ciclo de producción del lote
Todos los procesos que el lote vive el lote deben tener un registro mediante este controlador
=end
class ControlLotesController < ApplicationController
  #Solicitar prueba de permisos antes de cargar cualquier acción
  load_and_authorize_resource
  before_action :set_lote
  before_action :collection_control_lotes, only: [:index, :show]
  before_action :data_from_tracking, only: [:index, :show]
  before_action :set_control_lotes, only: [:edit, :update, :update_cantidad, :destroy]
  before_action :sub_estados, only: [:new, :edit]

  # GET /control_lotes
  # GET /control_lotes.json
  def index
  end

  def show
    params[:plc] = params[:plc] || 'lotes'
    render action: :index
  end

  def new
    @control_lote = ControlLote.new
  end

  def create
    respond_to do |format|
      last_state_lote = @lote.control_lotes.last
      @control_lote = @lote.control_lotes.new(control_lote_params)
      if @control_lote.save
        Seguimiento.seguimientos_status_change(@lote.cantidad, @control_lote, current_user, "cambio_estado")
        last_state_lote.update(:resp_salida_id => current_user,
                               :fecha_salida => control_lote_params[:fecha_ingreso])
        format.html { redirect_to lote_control_lotes_path(:plc => params[:control_lote][:plc]) }
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
        format.html { redirect_to lote_control_lotes_path(:plc => params[:control_lote][:plc]) }
        flash[:success] = "Proceso actualizado correctamente"
      else
        sub_estados
        format.html { render :edit, :plc => params[:control_lote][:plc] }
        format.json { render json: @control_lote.errors, status: :unprocessable_entity }
      end
    end
  end

  # Para eliminar un proceso se valida que no sea el único existente para el lote. Después de esto se actualizan
  # los seguimientos del anterior proceso y el proceso anterior para que todo pueda ser como antes de que se creara
  # el proceso que se va a eliminar
  def destroy
    data = {}
    status = ""
    if @lote.control_lotes.count > 1
      set_prev_seguimiento
      prev_control
      @id = @control_lote.id
      @control_lote.destroy
      data = {status: :ok}
    else
      # La petición ha sido aceptada para procesamiento, pero este no ha sido completado. La petición eventualmente
      # pudiere no ser satisfecha, ya que podría ser no permitida o prohibida cuando el procesamiento tenga lugar.
      data = {status: :accepted, json: "No se puede eliminar el único registro del ciclo para el lote"}
    end
    respond_to do |format|
      format.js { render :destroy, data }
    end
  end

  def update_cantidad
    cantidad_params = params.require(:control_lote).permit(:cantidad)
    respond_to do |format|
      if @control_lote.update(cantidad_params)
        after = ControlLote.after_before @lote
        format.json { render json: {
            total: @lote.control_lotes.sum(:cantidad),
            after: after
        }, status: :ok }
      else
        format.json { render json: "No se puede procesar", status: :unprocessable_entity }
      end
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

  def collection_control_lotes
    company = session[:selected_company]
    @control_lotes = @lote.control_lotes
    @user = {}
    @users = User.select("id, name").each { |e| @user[e.id] = e.name }
  end

  def data_from_tracking
    @seguimiento = Seguimiento.new
  end

  def set_prev_seguimiento
    this = ControlLote
    c_prev = this.prev(@control_lote, @control_lote.lote)
    prev = c_prev.is_a?(ControlLote) ? c_prev.seguimientos.last : nil
    if prev
      prev.update(cantidad: @control_lote.cantidad_last + prev.cantidad, fecha_salida: nil)
    end
  end

  def prev_control
    @control = ControlLote.prev(@control_lote, @control_lote.lote)
    @control.update(fecha_salida: nil, resp_salida_id: nil) if @control_lote == @lote.control_lotes.last
  end
end
