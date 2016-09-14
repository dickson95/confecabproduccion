class ClientesController < ApplicationController
  before_action :set_cliente, only: [:show, :edit, :update, :destroy]
  #Solicitar prueba de permisos antes de cargar cualquier acción
  load_and_authorize_resource :except => [:create, :send_email]

  # GET /clientes
  # GET /clientes.json
  def index
    @clientes = Cliente.all
  end

  # GET /clientes/1
  # GET /clientes/1.json
  def show
  end

  # GET /clientes/new
  def new
    @cliente = Cliente.new
  end

  # GET /clientes/1/edit
  def edit
  end

  # POST /clientes
  # POST /clientes.json
  def create
    @cliente = Cliente.new(cliente_params)
    respond_to do |format|
      if @cliente.save
        if params[:place] == "form_lote_cliente_response"
          @lote = Lote.new
          @clientes = Cliente.all
          @cliente = Cliente.last
          format.js {render "lotes/ajaxResults"}
        else
          format.html { redirect_to @cliente }
          flash[:success] = "Cliente guardado con éxito."
          format.json { render :show, status: :created, location: @cliente }
        end
      else
        if params[:place] == "form_lote_cliente_response"
          format.html
          format.json { render json: @cliente.errors, status: :unprocessable_entity }
          format.js {render "/lotes/ajaxResultsValidates"}
        else
          format.html { render :new }
          format.json { render json: @cliente.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /clientes/1
  # PATCH/PUT /clientes/1.json
  def update
    respond_to do |format|
      if @cliente.update(cliente_params)
        format.html { redirect_to @cliente }
        flash[:success] = "Actualización correcta."
        format.json { render :show, status: :ok, location: @cliente }
      else
        format.html { render :edit }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clientes/1
  # DELETE /clientes/1.json
  def destroy
    @cliente.destroy
    respond_to do |format|
      format.html { redirect_to tipos_prendas_path }
      flash[:success] = "Cliente eliminado."
      format.json { head :no_content }
    end
  end
  
  # Enviar correo electrónico por problemas con los insumos al cliente 
  def send_email
    @cliente = Cliente.new(cliente_params)
    puts "Mensaje desde el parmámetro #{params[:mensaje]}"
    puts "Mensaje desde el controlador #{@cliente.mensaje}"
    InsumosMailer.insumos(@cliente).deliver
    respond_to do |format|
      format.js {render "/lotes/ajaxResults"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente
      @cliente = Cliente.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cliente_params
      params.require(:cliente).permit(:cliente, :telefono, :direccion, :email,
      :mensaje, :asunto)
    end
end

