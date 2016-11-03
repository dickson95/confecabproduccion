class TiposPrendasController < ApplicationController
  before_action :set_tipo_prenda, only: [:show, :edit, :update, :destroy]
  #Solicitar prueba de permisos antes de cargar cualquier acción
  load_and_authorize_resource :except  => [:create]
  # GET /tipos_prendas
  # GET /tipos_prendas.json
  def index
    @tipos_prendas = TipoPrenda.all
  end

  # GET /tipos_prendas/1
  # GET /tipos_prendas/1.json
  def show
  end

  # GET /tipos_prendas/new
  def new
    @tipo_prenda = TipoPrenda.new
  end

  # GET /tipos_prendas/1/edit
  def edit
  end

  # POST /tipos_prendas
  # POST /tipos_prendas.json
  def create
    @tipo_prenda = TipoPrenda.new(tipo_prenda_params)

    respond_to do |format|
      if @tipo_prenda.save
        if params[:place] == "form_lote_response"
          @lote = Lote.new
          @tipos_prendas = TipoPrenda.all
          @tipo_prenda = TipoPrenda.last
          format.js {render "/lotes/ajaxResults"}
        else
          format.html { redirect_to tipos_prendas_path}
          flash[:success] = "Descripción creada correctamente"
          format.json { render :show, status: :created, location: @tipo_prenda }
        end
      else
        if params[:place] == "form_lote_response"
          format.html { render :new }
          format.js {render "/lotes/ajaxResultsValidates"}
          format.json { render json: @tipo_prenda.errors, status: :unprocessable_entity }
        else
          format.html { render :new }
          format.json { render json: @tipo_prenda.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /tipos_prendas/1
  # PATCH/PUT /tipos_prendas/1.json
  def update
    respond_to do |format|
      if @tipo_prenda.update(tipo_prenda_params)
        format.html { redirect_to tipos_prendas_path}
        flash[:success] = "Descripción actualizada"
        format.json { render :show, status: :ok, location: @tipo_prenda }
      else
        format.html { render :edit }
        format.json { render json: @tipo_prenda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipos_prendas/1
  # DELETE /tipos_prendas/1.json
  def destroy
    @tipo_prenda.destroy
    respond_to do |format|
      format.html { redirect_to tipos_prendas_url }
      flash[:success] = "Descripción eliminada."
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_prenda
      @tipo_prenda = TipoPrenda.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipo_prenda_params
      params.require(:tipo_prenda).permit(:tipo)
    end
end
