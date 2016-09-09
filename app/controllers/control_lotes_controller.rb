class ControlLotesController < ApplicationController
  before_action :set_control_lote, only: [:show, :update, :destroy]
  #Solicitar prueba de permisos antes de cargar cualquier acción
  load_and_authorize_resource 
  
  # GET /control_lotes
  # GET /control_lotes.json
  def index
    @control_lotes = ControlLote.order('lote_id').all
  end

  # GET /control_lotes/1
  # GET /control_lotes/1.json
  def show
  end

  # GET /control_lotes/new
  def new
    @control_lote = ControlLote.new
  end


  # POST /control_lotes
  # POST /control_lotes.json
  def create
    @control_lote = ControlLote.new(control_lote_params)

    respond_to do |format|
      if @control_lote.save
        format.html { redirect_to @control_lote, notice: 'Control lote was successfully created.' }
        format.json { render :show, status: :created, location: @control_lote }
      else
        format.html { render :new }
        format.json { render json: @control_lote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /control_lotes/1
  # PATCH/PUT /control_lotes/1.json
  def update
    respond_to do |format|
      if @control_lote.update(control_lote_params)
        format.html { redirect_to @control_lote, notice: 'Control lote was successfully updated.' }
        format.json { render :show, status: :ok, location: @control_lote }
      else
        format.html { render :edit }
        format.json { render json: @control_lote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /control_lotes/1
  # DELETE /control_lotes/1.json
  def destroy
    @control_lote.destroy
    respond_to do |format|
      format.html { redirect_to control_lotes_url, notice: 'Control lote was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_control_lote
      @control_lote = ControlLote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def control_lote_params
      params.require(:control_lote).permit(:sub_estado, :lote_id, :fecha_ingreso, 
      :fecha_salida,:responsable_ingreso, :responsable_salida, :estado_id)
    end
end
