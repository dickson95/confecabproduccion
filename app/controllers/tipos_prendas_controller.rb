class TiposPrendasController < ApplicationController
  load_and_authorize_resource :except  => [:index]
  before_action :set_tipo_prenda, only: [:show, :edit, :update, :destroy]
  #Solicitar prueba de permisos antes de cargar cualquier acción
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
    respond_to do |format|
      format.js{ render 'lotes/ajaxResults' }
      format.html
    end
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
        format.html { render :new }
        format.js {render "/lotes/ajaxResultsValidates"}
        format.json { render json: @tipo_prenda.errors, status: :unprocessable_entity }
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
    bef_delete = Before::Delete.new
    respond_to do |format|
      if bef_delete.child_records(@tipo_prenda)
        format.json { render json: "Algunos lotes dependen esta descripción. No se puede eliminar", status: :conflict }
      else
        @tipo_prenda.destroy
        data= { message: "Descripción eliminada con éxito" }
        format.json { render json: data }
      end
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
