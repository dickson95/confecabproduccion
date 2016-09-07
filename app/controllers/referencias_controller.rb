class ReferenciasController < ApplicationController
  before_action :set_referencia, only: [:show, :edit, :update, :destroy]
  #Solicitar prueba de permisos antes de cargar cualquier acción
  load_and_authorize_resource 
  
  # GET /referencias
  # GET /referencias.json
  def index
    @referencias = Referencia.all
  end

  # GET /referencias/1
  # GET /referencias/1.json
  def show
  end

  # GET /referencias/new
  def new
    @referencia = Referencia.new
  end

  # GET /referencias/1/edit
  def edit
  end

  # POST /referencias
  # POST /referencias.json
  def create
    @referencia = Referencia.new(referencia_params)

    respond_to do |format|
      if @referencia.save
        format.html { redirect_to @referencia, notice: 'Nueva referencia registrada con éxito.' }
        format.json { render @referencia, status: :created, location:  @referencia }
      else
        format.html { render :new }
        format.json { render json: @referencia.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /referencias/1
  # PATCH/PUT /referencias/1.json
  def update
    respond_to do |format|
      if @referencia.update(referencia_params)
        format.html { redirect_to @referencia, notice: 'Referencia actualizada correctamente.' }
        format.json { render :show, status: :ok, location: @referencia }
      else
        format.html { render :edit }
        format.json { render json: @referencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /referencias/1
  # DELETE /referencias/1.json
  def destroy
    @referencia.destroy
    respond_to do |format|
      format.html { redirect_to tipos_prendas_path, notice: 'Referencia eliminada.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_referencia
      @referencia = Referencia.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def referencia_params
      params.require(:referencia).permit(:referencia)
    end
end
