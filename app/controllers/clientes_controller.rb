class ClientesController < ApplicationController
  before_action :set_cliente, only: [:show, :edit, :update, :destroy]
  before_action :collection_clientes, only: [:show, :index]
  #Solicitar prueba de permisos antes de cargar cualquier acción
  load_and_authorize_resource :except => [:create, :send_email]

  # GET /clientes
  # GET /clientes.json
  def index
  end

  # GET /clientes/1
  # GET /clientes/1.json
  def show
    respond_to do |format|
      format.html { render action: :index }
      format.js
    end
  end

  # GET /clientes/new
  def new
    @cliente = Cliente.new
    respond_to do |format|
      format.js { render 'lotes/ajaxResults' }
      format.html
    end
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
        @lote = Lote.new
        @clientes = Cliente.where(:empresa => session[:selected_company])
        @cliente = Cliente.last
        format.js { render "lotes/ajaxResults" }
        format.html { redirect_to @cliente, notice: "Cliente guardado con éxito." }
        format.json { render :show, status: :created, location: @cliente }
      else
        format.html { render :new }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
        format.js { render "lotes/ajaxResultsValidates" }
      end
    end
  end

  # PATCH/PUT /clientes/1
  # PATCH/PUT /clientes/1.json
  def update
    respond_to do |format|
      if @cliente.update(cliente_params)
        @cliente.reload
        format.html { redirect_to clientes_path }
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
    bef_delete = Before::Delete.new
    respond_to do |format|
      if bef_delete.child_of_relation(@cliente, :lotes)
        format.json { render json: "Algunos lotes dependen de este cliente. No se puede eliminar.", status: :conflict }
      else
        @cliente.destroy
        format.json { render json: {message: "Cliente eliminado con éxito"} }
      end
    end
  end

  # Enviar correo electrónico por problemas con los insumos al cliente 
=begin
  def send_email
    @cliente = Cliente.new(cliente_params)
    puts "Mensaje desde el parmámetro #{params[:mensaje]}"
    puts "Mensaje desde el controlador #{@cliente.mensaje}"
    InsumosMailer.insumos(@cliente).deliver
    respond_to do |format|
      format.js {render "/lotes/ajaxResults"}
    end
  end
=end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_cliente
    @cliente = Cliente.find(params[:id])
  end

  def collection_clientes
    gon.clientes = can?(:destroy, Cliente) || can?(:update, Cliente)
    @clientes = Cliente.where(:empresa => session[:selected_company]).order("id desc")
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cliente_params
    empresa = params[:cliente][:empresa]
    params[:cliente][:empresa] = util.to_boolean empresa
    params.require(:cliente).permit(
        :nit,
        :cliente,
        :tiempo_pago,
        :direccion,
        :empresa,
        :observaciones,
        telefonos_attributes:
            [
                :id,
                :telefono,
                :_destroy,
                extensiones_attributes:
                    [
                        :id,
                        :extension,
                        :_destroy,
                        contacto_attributes:
                            [
                                :id,
                                :contacto,
                                :cargo,
                                :_destroy,
                                correos_attributes:
                                    [
                                        :id,
                                        :correo,
                                        :_destroy
                                    ]
                            ]
                    ]
            ]
    )
  end
end

