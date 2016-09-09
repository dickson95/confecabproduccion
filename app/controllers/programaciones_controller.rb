class ProgramacionesController < ApplicationController
  before_action :set_programacion, only: [:show, :edit, :update, :destroy]
  #Solicitar prueba de permisos antes de cargar cualquier acción
  load_and_authorize_resource :class => "Lote"

  # GET /programaciones
  # GET /programaciones.json
  def index
    @programacion_lotes = Lote.joins(:control_lotes).
    where(['control_lotes.estado_id=?', 2]).
    order('control_lotes.fecha_ingreso asc')
    num = Lote.sum(:precio_t)
    @costo_total = Lote.str_pesos(num)
    @horas_t = Lote.sum(:h_req)
  end

  # GET /programaciones/1
  # GET /programaciones/1.json
  def show
    respond_to do |format|
      format.js
      format.html
    end
  end

  # GET /programaciones/new
  def new
    @programacion = Programacion.new
  end

  # GET /programaciones/1/edit
  def edit
  end

  # POST /programaciones
  # POST /programaciones.json
  def create
    @programacion = Programacion.new(programacion_params)

    respond_to do |format|
      if @programacion.save
        format.html { redirect_to @programacion, notice: 'Programacion was successfully created.' }
        format.json { render :show, status: :created, location: @programacion }
      else
        format.html { render :new }
        format.json { render json: @programacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /programaciones/1
  # PATCH/PUT /programaciones/1.json
  def update
    print "actualización de programación"
    respond_to do |format|
      if @programacion_lote.update(programacion_params)
        format.html { redirect_to programacion_path, notice: 'Programacion actualizada.' }
        format.json { render :show, status: :ok, location: programacion_path}
      else
        format.html { render :edit }
        format.json { render json: @programacion_lote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /programaciones/1
  # DELETE /programaciones/1.json
  def destroy
    @programacion.destroy
    respond_to do |format|
      format.html { redirect_to programaciones_url, notice: 'Programacion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_programacion
      @programacion_lote = Lote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def programacion_params
      params.require(:lote).permit(:secuencia, 
      :precio_u, :precio_t, :mes, :descripcion,
      :meta, :h_req, :can_integracion)
    end

end
