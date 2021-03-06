=begin
  CONTROLADOR DE LOTES
Todas las acciones a la vista de acuerdo con el paradigma MVC
=end
class LotesController < ApplicationController
  # Validación de autorización
  load_and_authorize_resource :except => [:view_details]
  include LotesHelper
  include LotesDatatablesHelper
  # Acciones primarias
  before_action :rol_user, only: [:create, :update, :edit, :new]
  before_action :set_color, only: [:create, :update]
  before_action :set_tipo_prenda, only: [:new, :edit]
  before_action :set_lote, only: [:edit, :update, :update_ingresara_a_planta, :update_programacion, :destroy]
  before_action :set_talla, only: [:view_details, :new, :edit, :create, :update]
  before_action :time, only: [:cambio_estado]

  # Autocompletado
  autocomplete :color, :color

  # GET /lotes
  # GET /lotes.json
  def index
    @estados = Estado.active.order(:secuencia)
    respond_to do |format|
      format.html
      format.js
      format.json { render json: data_tables(params) }
    end
  end

  def view_details
    lote_id = params.permit(:lote_id)
    @lote = ControlLote.where(lote_id: lote_id[:lote_id]).max
    respond_to do |format|
      format.js
    end
  end

  # GET /lotes/new
  def new
    @lote = Lote.new
    @colores_lotes = @lote.colores_lotes.build
    @cantidades = @colores_lotes.cantidades.build
    @control_lote = @lote.control_lotes.build
  end

  # GET /lotes/1/edit
  def edit
    # Si cuando el lote fue guardado se guardó sin tener detalles de las
    # cantidades se construye un grupo nuevo de campos para el formulario
    if @lote.colores_lotes.empty?
      @colores_lotes = @lote.colores_lotes.build
      (0..8).each { |n| @cantidades = @colores_lotes.cantidades.build }
    else
      # En caso de tenerlos, se adapta la situación para que imprima lo que ya existe en 
      # en el formulario
      @totales = Array.new
      @colores = Array.new
      @totales_tallas = Array.new
      @lote.colores_lotes.each do |cl|
        @totales.push cl.total.total
        @colores.push cl.color.color
        cl.cantidades.each do |c|
          @totales_tallas.push c.total.total
        end
      end
    end
  end


  # POST /lotes
  # POST /lotes.json
  def create
    # Definir si la op existe. Retorna true si puede ser creada
    @lote = Lote.new(lote_params)
    respond_to do |format|
      if @color_blank
        if @lote.save
          @control = @lote.control_lotes.last
          @control.update(resp_ingreso_id: current_user, fecha_ingreso: Time.new)
          @control.seguimientos.new(cantidad: @lote.cantidad).save
          format.html { redirect_to lotes_path }
        else
          invalid = true
        end
      else
        invalid = true
        @lote.errors.add :colores_lotes
      end
      if invalid
        set_tipo_prenda
        if @remove
          @colores_lotes = @lote.colores_lotes.build
          (0..8).each { |n| @cantidades = @colores_lotes.cantidades.build }
        end
        format.html { render :new }
        format.json { render json: @lote.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /lotes/1
  # PATCH/PUT /lotes/1.json
  def update
    respond_to do |format|
      if @lote.update(lote_params_update) && @color_blank
        format.html { redirect_to "/#{params[:lote][:plc]}" }
        flash[:success] = "Lote actualizado correctamente"
      else
        set_tipo_prenda
        if !@color_blank
          @lote.errors.add :colores_lotes
        end
        format.html { render :edit }
        format.json { render json: @lote.errors, status: :unprocessable_entity }
      end
    end
  end

  # Pasar entre los distintos estados del lote y registrar las fechas de salida
  # de un estado, la de entrada al siguiente y un responsable por acción
  def cambio_estado
    this = Lote
    @next_estado = Estado.find params[:btn] # Lote siguiente del actual
    @estado = @next_estado.id # Este es el estado que sigue del actual
    @men = @next_estado.estado
    has_programing = this.has_programing(params[:lote_id], @estado)

    if has_programing
      # Actualización de fecha para el último estado
      @lote = this.find(params[:lote_id])
      # Asignación de parámetros para el nuevo control a registrar. Responsable
      # por el movimiento
      @control = ControlLote.new(:lote_id => params[:lote_id], :estado_id => @estado,
                                      :fecha_ingreso => @time, :resp_ingreso_id => current_user)
      respond_to do |format|
        # Nuevo estado en el historial de los lotes
        if @control.save
          Seguimiento.seguimientos_status_change(@lote.cantidad, @control, current_user, action_name)
          reqfor = request.format # formato de la solicitud
          if reqfor == "application/json" || reqfor == "text/javascript"
            format.json { render json: json_cambio_estado, status: :ok }
            format.js { render 'control_lotes/cambio_estado' }
          else
            format.html { redirect_to :back }
            flash[:info] = "Lote #{men=="completado" ? men : "cambiado a #{men}"}."
          end

        else
          format.html { redirect_to lotes_path }
          flash[:danger] = "Ocurrio un error, intenta de nuevo"
        end
      end
    else
      respond_to do |format|
        if request.format == "text/javascript"
          format.html { render partial: 'dropdown_options', locals: {lote_id: params[:lote_id], estado_id: @estado - 1},
                               status: :not_modified }
        else
          format.html { redirect_to :back }
        end

      end
    end
  end

  def update_ingresara_a_planta
    respond_to do |format|
      if @lote.update(params.require(:lote).permit(:ingresara_a_planta))
        format.json { render json: @lote, status: :ok }
      else
        head :bad_request # Código 400 en los estados HTTP
      end
    end
  end

  def update_programacion
    par = params.require(:lote).permit(:year, :month, :day)
    par[:month] = "0#{par[:month]}" if par[:month].to_i < 10
    programacion = Programacion.get_per_month("#{par[:year]}#{par[:month]}", session[:selected_company])
    respond_to do |format|
      if @lote.update(:programacion_id => programacion.first.id, :ingresara_a_planta => "#{par[:year]}-#{par[:month]}-#{par[:day]}")
        format.json { render json: @lote, status: :ok }
      else
        head :bad_request # Código 400 en los estados HTTP
      end
    end
  end

  # DELETE /lotes/1
  # DELETE /lotes/1.json
  def destroy
    @lote.destroy
    render json: {message: "Lote eliminado."}, status: :ok
  end

  # PATCH /lotes/:lote_id/total_price
  # Actualiza los precios (total y unitario) del lote
  def total_price
    lote_price = params.require(:lote).permit(:amount, :unit_price)
    lote_price[:unit_price] = Lote.functional_format lote_price[:unit_price]
    price_total = Lote.multiplication(lote_price.values)
    format_price_u = Money.from_amount(lote_price[:unit_price].to_i, "COP").format(:no_cents => true)
    format_price_t = Money.from_amount(price_total.to_i, "COP").format(:no_cents => true)
    Lote.update(params[:id].to_i, :precio_u => lote_price[:unit_price], :precio_t => price_total, :respon_edicion_id => current_user)
    @prices = {:total => format_price_t, :unit => format_price_u}
    respond_to do |format|
      format.json { render json: @prices }
    end
  end

  def options_export
    company = session[:selected_company]
    @clientes = Cliente.all.where(:empresa => company)
  end

  def export_excel
    # Hash con las claves y valores que fueron seleccionados
    @keys = Lote.set_keys_query permit_export
    company = session[:selected_company] ? "CAB" : "D&C"
    permit = Hash.new
    permit[:from] = params[:export][:from]
    permit[:to] = params[:export][:to]
    permit[:clientes] = params[:export][:clientes]

    @lotes = Lote.query_filtered permit, company
    company = session[:selected_company] ? "Confecab" : "Diseños y camisas"
    respond_to do |format|
      format.xlsx { render xlsx: "export_excel", filename: "Lotes de #{company}" }
    end
  end

  # POST /lotes/:lote_id/
  def validate_op
    op_param = params.permit(:op, :lote_id)
    company = session[:selected_company] ? "CAB" : "D&C"
    lote_id = op_param[:lote_id] == "undefinded" ? nil : op_param[:lote_id]
    val_op = Lote.validate_op(op_param[:op], company, lote_id)
    respond_to do |format|
      format.json { render json: val_op }
    end
  end

  private
  def set_lote
    @lote = Lote.find(params[:id])
  end

  def set_tipo_prenda
    @tipos_prendas = TipoPrenda.all
    @clientes = Cliente.where(:empresa => session[:selected_company])
    @sub_estados = SubEstado.all
  end

  def set_lote_u
    @lote = ControlLote.where(lote_id: params[:lote_id]).max
  end

  def set_talla
    @tallas = Talla.all
  end

  def set_referencia
    id = Referencia.find_or_create_by(:referencia => params[:lote][:referencia])
    id.id
  end

  # Validación de los datos del color.
  # Define que para todas las tallas exista por lo menos una cantidad mayor a 0
  # Determina que el campo para el color no esté vacío
  # Asigna las variables correspondientes para reanudar el formulario en caso de fallar esta validación.
  # Cómo buena práctica debería estar en el modelo de lote o de color. Puede ser pasado teniendo presentes todas las
  # implicaciones en ello
  def set_color
    # Totales: Array para los totales por tallas
    totales = Array.new
    color_id = nil
    total_cantidades_id = nil
    total_colores_id = nil
    bool = true
    recorrer_una = true

    # Zona de acción en caso de que las validaciones correspondientes
    # sean inválidas
    # remove: Indica si debe armarse de nuevo el formulario de detalles de cantidades
    # colores: Toma los colores de los parámetros antes de que sean analizados para
    # que no se pierdan para la vista
    # color_blank: Retorna true si hay un color
    # totales: totales relativos por color
    # totales_tallas: totales por talla
    @remove = false
    @color_blank = true
    @colores = Array.new
    @totales = Array.new
    @totales_tallas = Array.new
    colores = params[:lote][:colores_lotes_attributes]

    if !colores.nil?
      colores.each do |k, v|

        if recorrer_una
          v[:cantidades_attributes].each do |k2, v2|
            @totales_tallas.push v2[:total_id]
          end
          recorrer_una = false
        end

        @colores.push v[:color]
        @totales.push v[:total_id]
      end

      # Decisión para retirar o no el array del color, retira los colores que no tienen
      # descripción
      colores.each do |k, v|
        cont = 0

        # Validar que entre los 9 parámetros hay algún número distinto de 0
        # si así es, se dejan los parámetro intactos
        params[:lote][:colores_lotes_attributes][:"#{k}"][:cantidades_attributes].each do |k2, v2|
          if v2[:cantidad] == "0" && cont < 9
            cont += 1
          else
            break
          end
        end

        # Si el contador es menor a 8 significa que en los 9 campos hay un número distinto
        # de 0, es decir, máximos se encuentran 8 ceros y cumple con la validación de que
        # exista un número mayor a 0
        if cont < 8

          if v[:color] == ""
            @color_blank = false
          end
          color_id = Color.find_or_create_by(:color =>
                                                 params[:lote][:colores_lotes_attributes][:"#{k}"][:color])
          v[:color_id] = color_id.id

          total_colores_id = Total.find_or_create_by(:total =>
                                                         params[:lote][:colores_lotes_attributes][:"#{k}"][:total_id])
          v['total_id'] = total_colores_id.id


          i = 0
          # Recorrer parámetros de cantidades_attributes para asignar el total real

          params[:lote][:colores_lotes_attributes][:"#{k}"][:cantidades_attributes].each do |k2, v2|

            if bool
              # Se hace revisión de la primara fila de totales y se establecen
              # en la base de datos y en el array de totales
              total_cantidades_id = Total.find_or_create_by(:total =>
                                                                params[:lote][:colores_lotes_attributes][:"#{k}"][:cantidades_attributes][:"#{k2}"][:total_id])
              v2['total_id'] = total_cantidades_id.id
              totales.push(v2['total_id'])

            else
              # Con el fin de evitar más consultas sobre la base de datos
              # se usa el array para poder establecer el parámetro total_id

              v2['total_id'] = totales.fetch(i)
              i = i + 1

            end
          end

          # "bool" es asignada como false para evitar que se repitan las consultas
          # contra la base de datos del ciclo anterior
          bool = false
          @remove = false
        else
          # Sino se cumple la condición de existir un número mayor a 0
          params[:lote][:colores_lotes_attributes].delete(k)
          @remove = true
        end
      end
    end
    #Rails.logger.info("PARAMS: #{params.inspect}")
  end

  def lote_params
    sub_id_value
    params.require(:lote).permit(:empresa, :color_prenda, :programacion_id,
                                 :no_remision, :no_factura, :cliente_id, :tipo_prenda_id, :prioridad,
                                 :op, :fecha_entrada, :fin_insumos, :obs_insumos, :meta, :h_req,
                                 :obs_integracion, :fin_integracion, :cantidad, :precio_u, :precio_t,
                                 :fecha_revision, :fecha_entrega, :control_lotes_attributes => [:id,
                                                                                                :sub_estado_id, :lote_id, :fecha_ingreso, :fecha_salida, :estado_id, :_destroy],
                                 :colores_lotes_attributes => [:id, :color_id, :lote_id, :total_id, :_destroy,
                                                               :cantidades_attributes => [:id, :categoria_id, :total_id, :cantidad, :_destroy]]).
        merge(respon_edicion_id: current_user, referencia_id: set_referencia)
  end

  def lote_params_update
    params.require(:lote).permit(:empresa, :color_prenda, :programacion_id,
                                 :no_remision, :no_factura, :fin_insumos, :obs_insumos,
                                 :obs_integracion, :fin_integracion, :precio_u, :meta, :h_req,
                                 :cliente_id, :tipo_prenda_id, :prioridad, :op, :fecha_entrada,
                                 :fecha_revision, :fecha_entrega, :cantidad, :precio_t, :programacion,
                                 :colores_lotes_attributes => [:id, :color_id, :lote_id, :total_id, :_destroy,
                                                               :cantidades_attributes => [:id, :categoria_id, :total_id, :cantidad, :_destroy]]).
        merge(respon_edicion_id: current_user, referencia_id: set_referencia)
  end

  def permit_export
    params.require(:export)
        .permit(:no_remision, :no_factura, :op, :fecha_revision,
                :fecha_entrega, :obs_insumos, :fin_insumos, :referencia_id, :cliente_id, :tipo_prenda_id,
                :meta, :h_req, :precio_u, :precio_t, :secuencia, :obs_integracion, :fin_integracion,
                :fecha_entrada, :cantidad, :programacion_id, :created_at)
  end

  def sub_id_value
    control_attributes = params[:lote][:control_lotes_attributes]
    if !control_attributes.nil?
      if control_attributes[:'0'][:sub_estado_id] == ""
        control_attributes[:'0'][:sub_estado_id] = "0"
      end
    end
  end

  def rol_user
    if user_signed_in?
      @rol_form = nil
      rol = current_user.roles
      (rol).each do |s|
        @rol_form = s.name
      end
    end
  end

  def time
    @time = Time.new
  end

  def json_cambio_estado
    json = Hash.new
    json[:dropdown] = view_context.render partial: 'dropdown_options', locals: {lote_id: params[:lote_id], estado_id: @estado}, formats: :html
    json[:estado] = @next_estado.as_json
    json[:message] = "Lote cambiado a #{@men}. <br> #{view_context.link_to "Ver ciclo", lote_control_lotes_path(@lote, plc: params[:plc])}"
    json[:lote] = @lote.as_json
    json
  end
end
