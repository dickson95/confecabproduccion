class UnidadesTiemposController < ApplicationController
  before_action :set_unidad_tiempo, only: [:show, :edit, :update, :destroy]

  # GET /unidades_tiempos
  # GET /unidades_tiempos.json
  def index
    @unidades_tiempos = UnidadTiempo.all
  end

  # GET /unidades_tiempos/1
  # GET /unidades_tiempos/1.json
  def show
  end

  # GET /unidades_tiempos/new
  def new
    @unidad_tiempo = UnidadTiempo.new
  end

  # GET /unidades_tiempos/1/edit
  def edit
  end

  # POST /unidades_tiempos
  # POST /unidades_tiempos.json
  def create
    @unidad_tiempo = UnidadTiempo.new(unidad_tiempo_params)

    respond_to do |format|
      if @unidad_tiempo.save
        format.html { redirect_to @unidad_tiempo, notice: 'Unidad tiempo was successfully created.' }
        format.json { render :show, status: :created, location: @unidad_tiempo }
      else
        format.html { render :new }
        format.json { render json: @unidad_tiempo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unidades_tiempos/1
  # PATCH/PUT /unidades_tiempos/1.json
  def update
    respond_to do |format|
      if @unidad_tiempo.update(unidad_tiempo_params)
        format.html { redirect_to @unidad_tiempo, notice: 'Unidad tiempo was successfully updated.' }
        format.json { render :show, status: :ok, location: @unidad_tiempo }
      else
        format.html { render :edit }
        format.json { render json: @unidad_tiempo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unidades_tiempos/1
  # DELETE /unidades_tiempos/1.json
  def destroy
    @unidad_tiempo.destroy
    respond_to do |format|
      format.html { redirect_to unidades_tiempos_url, notice: 'Unidad tiempo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unidad_tiempo
      @unidad_tiempo = UnidadTiempo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unidad_tiempo_params
      params.require(:unidad_tiempo).permit(:unidad, :segundos)
    end
end
