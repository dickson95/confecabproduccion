class SubEstadosController < ApplicationController
  before_action :set_sub_estado, only: [:show, :edit, :update, :destroy]
  #Solicitar prueba de permisos antes de cargar cualquier acción
  load_and_authorize_resource :except  => [:create]
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
    respond_to do |format|
      format.js { render 'lotes/ajaxResults' }
      format.html
    end
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
          format.js{ render 'lotes/ajaxResults' }
        else
          format.html { redirect_to sub_estados_path }
          flash[:success] = "Proceso registrado con éxito"
        end
      else
        format.html { render :new }
        format.js { render "lotes/ajaxResultsValidates" }
        format.json { render json: @sub_estado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_estados/1
  # PATCH/PUT /sub_estados/1.json
  def update
    respond_to do |format|
      if @sub_estado.update(sub_estado_params)
        format.html { redirect_to sub_estados_path }
        flash[:success] = "Proceso actualizado correctamente"
      else
        format.html { render :edit }
        format.json { render json: @sub_estado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_estados/1
  # DELETE /sub_estados/1.json
  def destroy
    bef_delete = Before::Delete.new
    respond_to do |format|
      if bef_delete.child_records(@sub_estado)
        format.json { render json: "Algunos ciclos de los lotes dependen de este proceso externo. No se puede eliminar.", status: :conflict }
      else
        @sub_estado.destroy
        data= { message: "Proceso externo eliminado" }
        format.json { render json: data }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_estado
      @sub_estado = SubEstado.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_estado_params
      params.require(:sub_estado).permit(:sub_estado)
    end
end
