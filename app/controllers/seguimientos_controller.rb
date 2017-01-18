class SeguimientosController < ApplicationController
  before_action :set_control_lote, only: [:create, :new]
  before_action :set_seguimiento, only: [:show, :edit, :update, :destroy]

  # GET /seguimientos
  # GET /seguimientos.json
  def index
    @seguimientos = Seguimiento.all
  end

  # GET /seguimientos/1
  # GET /seguimientos/1.json
  def show
  end

  # GET /seguimientos/new
  def new
    @seguimiento = Seguimiento.new
  end

  # GET /seguimientos/1/edit
  def edit
  end

  # POST /seguimientos
  # POST /seguimientos.json
  def create
    @seguimiento = process_or_reprocess
    respond_to do |format|
      if @seguimiento[:save]
        @control_lote.seguimientos.order("id desc").offset(1).limit(1).update(:fecha_salida => Time.new) if util.to_boolean(params[:seguimiento][:process])
        format.json { render json: json_response, status: :created }
      else
        format.json { render json: @seguimiento[:seguimiento].errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seguimientos/1
  # PATCH/PUT /seguimientos/1.json
  def update
    respond_to do |format|
      if @seguimiento.update(seguimiento_params)
        format.html { redirect_to @seguimiento, notice: 'Seguimiento was successfully updated.' }
        format.json { render :show, status: :ok, location: @seguimiento }
      else
        format.html { render :edit }
        format.json { render json: @seguimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seguimientos/1
  # DELETE /seguimientos/1.json
  def destroy
    @seguimiento.destroy
    respond_to do |format|
      format.html { redirect_to seguimientos_url, notice: 'Seguimiento was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_control_lote
    @control_lote = ControlLote.find(params[:control_lote_id])
  end

  def set_seguimiento
    @seguimiento = Seguimiento.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def seguimiento_params
    params.require(:seguimiento).permit(:cantidad, :control_lote_id, :proceso)
  end

  def json_response
    {
        seguimiento: @seguimiento[:seguimiento],
        seg_prev: ControlLote.prev(@control_lote, @control_lote.lote).seguimientos.last
    }
  end

  def process_or_reprocess
    param_amo = seguimiento_params[:cantidad]
    # Evitar que si el valor del usuario viene vacío pueda ser válido
    blank =  param_amo.strip!="" && param_amo.to_i > 0
    # Si es por proceso normal
    if util.to_boolean(params[:seguimiento][:proceso])
      amount = param_amo.to_i + @control_lote.cantidad_last if blank
      Seguimiento.seguimientos_status_change(amount, @control_lote, current_user, action_name)
    else # Si es por reproceso
      seguimiento = @control_lote.seguimientos.new(seguimiento_params)
      seguimiento.return_units(param_amo.to_i)
    end
  end
end
