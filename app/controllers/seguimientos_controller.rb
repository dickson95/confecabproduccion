class SeguimientosController < ApplicationController
  before_action :set_control_lote, only: [:create]
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
    param_amo = seguimiento_params[:cantidad]
    amount =  param_amo.strip==""|| param_amo=="0" ? nil : param_amo.to_i + @control_lote.cantidad_last
    @seguimiento = Seguimiento.seguimientos_status_change(amount, @control_lote, action_name)
    respond_to do |format|
      if @seguimiento[:save]
        save = @control_lote.seguimientos.order("id desc").offset(1).limit(1).update(:fecha_salida => Time.new)
        puts "actualizado último #{save}"
        format.json { render json: @seguimiento[:seguimiento], status: :created }
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
    params.require(:seguimiento).permit(:cantidad, :control_lote_id)
  end
end
