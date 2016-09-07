class SubEstadosController < ApplicationController
  before_action :set_sub_estado, only: [:show, :edit, :update, :destroy]
  #Solicitar prueba de permisos antes de cargar cualquier acción
  load_and_authorize_resource 
  # GET /sub_estados
  # GET /sub_estados.json
  def index
    @sub_estados = SubEstado.all
  end

  # GET /sub_estados/1
  # GET /sub_estados/1.json
  def show
  end

  # GET /sub_estados/new
  def new
    @sub_estado = SubEstado.new
  end

  # GET /sub_estados/1/edit
  def edit
  end

  # POST /sub_estados
  # POST /sub_estados.json
  def create
    @sub_estado = SubEstado.new(sub_estado_params)

    respond_to do |format|
      if @sub_estado.save
        if params[:place] == "form_lote_sub_estado_response"
          @lote = Lote.new
          @sub_estados = SubEstado.all
          @sub_estado = SubEstado.last
          params[:estado_id] = @sub_estado.estado.id
          format.js{ render 'lotes/ajaxResults' }
        else
          format.html { redirect_to tipos_prendas_path, 
          notice: 'Proceso registrado con éxito' }
        end
      else
        format.html { render :new }
        format.json { render json: @sub_estado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_estados/1
  # PATCH/PUT /sub_estados/1.json
  def update
    respond_to do |format|
      if @sub_estado.update(sub_estado_params)
        format.html { redirect_to tipos_prendas_path, 
        notice: 'Proceso actualizado correctamente' }
      else
        format.html { render :edit }
        format.json { render json: @sub_estado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_estados/1
  # DELETE /sub_estados/1.json
  def destroy
    @sub_estado.destroy
    respond_to do |format|
      format.html { redirect_to tipos_prendas_path, notice: 'Proceso eliminado con éxito' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_estado
      @sub_estado = SubEstado.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_estado_params
      params.require(:sub_estado).permit(:sub_estado, :estado_id)
    end
end
