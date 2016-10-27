class LotesController < ApplicationController
  include LotesHelper
  # Acciones primarias
  before_action :rol_user, only: [:create, :update, :edit, :new]
  before_action :set_color, only: [:create, :update]
  before_action :set_tipo_prenda, only: [:new, :edit]
  before_action :referencia_params, only: [:set_referencia]
  before_action :set_lote, only: [:edit, :update, :destroy]
  before_action :set_lote_u, only: [:view_datails]
  before_action :set_talla, only: [:view_datails, :new, :edit, :create, :update]
  
  # Validación de autorización
  load_and_authorize_resource :except  => [:view_datails]
  
  # Autocompletado
  autocomplete :color, :color
  
  # GET /lotes
  # GET /lotes.json
  def index
    company = session[:selected_company]
    @lotes = Lote.joins([control_lotes: [:estado]], :referencia, :cliente)
    .where("control_lotes.fecha_ingreso = (SELECT MAX(fecha_ingreso) FROM control_lotes 
      cl GROUP BY lote_id HAVING cl.lote_id = control_lotes.lote_id) and lotes.empresa = '#{company ? "CAB" : "D&C"}'")
    .pluck("lotes.id", "clientes.cliente", "referencias.referencia", "lotes.op", "lotes.cantidad", 
      "lotes.tipo_prenda_id","control_lotes.estado_id","control_lotes.sub_estado_id", "lotes.precio_u", "lotes.precio_t")    
    @fechas_ingreso = ControlLote.hash_ids
    @tipos_prendas = TipoPrenda.hash_ids
  end
  
  def view_datails
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  # Añadir las tablas especificadas acá desde le formulario de lote
  def add_remote_data
    if params[:place] == "form_lote_cliente"
      @cliente = Cliente.new
    elsif params[:place] == "form_email_cliente"
      @cliente = Cliente.find(params[:cliente])
    elsif params[:place] == "form_lote_tipo_prenda"
      @tipo_prenda = TipoPrenda.new
    elsif params[:place] == "form_lote_sub_estado"
      @sub_estado = SubEstado.new
    end
    respond_to do |format|
      format.js{render 'ajaxResults'}
      format.html
    end
  end

  # GET /lotes/new
  def new
    @lote = Lote.new
    @colores_lotes = @lote.colores_lotes.build
    @cantidades = @colores_lotes.cantidades.build
  end

  # GET /lotes/1/edit
  def edit
    # Si cuando el lote fue guardado se guardó sin tener detalles de las
    # cantidades se construye un grupo nuevo de campos para el formulario
    if @lote.colores_lotes.empty?
      @colores_lotes = @lote.colores_lotes.build
      (0..8).each{|n| @cantidades = @colores_lotes.cantidades.build}
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
    puts @lote.programacion
    respond_to do |format|
      if @color_blank
        if @lote.save
          @lote = ControlLote.last
          ControlLote.where(:id => @lote.id).update(resp_ingreso_id: current_user, fecha_ingreso:  Time.new)  
          format.html{ redirect_to lotes_path }
        else
          invalid = true
        end
      else
        invalid = true
      end
      if invalid
        set_tipo_prenda
        if @remove
          @colores_lotes = @lote.colores_lotes.build
          (0..8).each{|n| @cantidades = @colores_lotes.cantidades.build } 
        end
        if !@color_blank
          @lote.errors.add :colores_lotes      
        end
        control = params[:lote][:control_lotes_attributes][:'0']
        params[:estado_id] = control[:estado_id]
        params[:sub_id] = control[:sub_estado_id]
        format.html { render :new }
        format.json { render json: @lote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lotes/1
  # PATCH/PUT /lotes/1.json
  def update
    boolean = false
    # Se consulta el último estado del lote para ser comparado con el actual
    lote = ControlLote.where(lote_id: params[:id]).joins(:estado)
            .order("control_lotes.id desc").limit(1)
            .pluck("estados.id", "control_lotes.fecha_ingreso",
              "control_lotes.id", "control_lotes.sub_estado_id", 
              "control_lotes.id").last
    # Id del estado en variable est_id
    if !params[:lote][:control_lotes_attributes].nil?
      est_id = params[:lote][:control_lotes_attributes][:'0'][:estado_id]
      if lote.fetch(0) == est_id.to_i
        # Si ninguna de las dos condiciones sigueintes se cumple no se crea nada en el historial

        # Id del subestado en variable sub_id
        sub_id = params[:lote][:control_lotes_attributes][:'0'][:sub_estado_id]

        if sub_id == ""
          # si el sub id no tiene nada desde el parámetro se asigna 0 para la comparación
          sub_id = 0
        end
        if lote.fetch(3) != sub_id.to_i
          # En caso de que el subestado sea diferente al anterior se crea uno nuevo
          boolean = true
          puts "Información: Creando un nuevo registro en el historial..."
        end
      else
        boolean = true
        puts "Información: Creando un registro completamente nuevo en el historial..."
      end
      @has_programing = Lote.has_programing params[:id], est_id
    else
      @has_programing = true
    end
    # Respuesta a la solicitud de actualización
    respond_to do |format|
      if @lote.update(boolean ? lote_params : lote_params_u ) && @has_programing && @color_blank
        if boolean
          # Actualizar fecha salida, responsable de salida, minutos del historial
          time = Time.new()
          updated = ControlLote.where(:id => lote.fetch(2)).update(fecha_salida: time)
          #Método de minutos
          $up
          updated.each{|u| $up = u.fecha_salida}
          min = Lote.minutos_proceso(lote.fetch(1), $up)
          ControlLote.where(:id => lote.fetch(2)).update(min_u: min,
            resp_salida_id: current_user)
          
          # Actualizar responsable de ingreso en el último historial
          ult = ControlLote.last
          ControlLote.where(:id => ult).update(resp_ingreso_id: current_user, fecha_ingreso: time,
            fecha_salida: est_id == "5" ? time : nil, resp_salida_id: est_id == "5" ? current_user : nil)
        end
        format.html{ redirect_to lotes_path }
        flash[:success] = "Lote actualizado correctamente"
      else
        set_tipo_prenda
        if !@has_programing  
          @lote.errors.add :control_lotes
        end
        if !@color_blank
          @lote.errors.add :colores_lotes
        end
        params[:estado_id] = params[:lote][:control_lotes_attributes][:'0'][:estado_id]
        params[:sub_id] = params[:lote][:control_lotes_attributes][:'0'][:sub_estado_id]
        
        format.html { render :edit }
        format.json { render json: @lote.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # Pasar entre los distintos estados del lote y registrar las fechas de salida
  # de un estado, la de entrada al siguiente y un responsable por acción
  def cambio_estado
    next_state_lote = next_state "", params[:btn]
    estado = next_state_lote[:state]
    men = next_state_lote[:message]
    has_programing = Lote.has_programing params[:id], estado

    if has_programing
      time = Time.new()
      #Actualización de fecha para el último estado
      id = ControlLote.where(["lote_id=?", params[:id]]).maximum(:id)
      ControlLote.where(:id => id).update(fecha_salida: time)
      lote = ControlLote.find(id)
      #método de minutos
      min = Lote.minutos_proceso(lote.fecha_ingreso, lote.fecha_salida)
      
      ControlLote.where(:id => id).update(min_u: min, 
        resp_salida_id: current_user)

      # Asignación de parámetros para el nuevo control a registrar. Responsable
      # por el movimiento
      @control_lote = ControlLote.new(:lote_id => params[:id], :estado_id => estado, 
        :fecha_ingreso => time, :resp_ingreso_id => current_user, :fecha_salida => estado == 5 ? time : nil,
        :resp_salida_id => estado == 5 ? current_user : nil)

      respond_to do |format|
        # Nuevo estado en el historial de los lotes
        if @control_lote.save
          format.html { redirect_to lotes_path }
          flash[:info] = "Lote #{men=="completado" ? men : "cambiado a #{men}"}." 
          format.json { render :index, status: :ok, location: @control_lote }
        else
          @lotes = ControlLote.select(:lote_id).map(&:lote_id).uniq
          format.html { render :index }
          format.json { render json: @control_lote.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html {redirect_to lotes_path}
        flash[:warning] = "El lote no tiene programación, no se puede confeccionar"
      end
    end
  end
  
  # DELETE /lotes/1
  # DELETE /lotes/1.json
  def destroy
    @lote.destroy
    render partial: 'layouts/messages', flash: flash[:info]='Registro eliminado con éxito'
  end

  # POST /lotes/:id/total_price
  def total_price
    lote_price = params.require(:lote).permit( :amount, :unit_price)
    lote_price[:unit_price] = Lote.functional_format lote_price[:unit_price]
    price_total = Lote.multiplication(lote_price.values)  
    format_price_u = Money.new("#{lote_price[:unit_price]}00").format
    format_price_t = Money.new("#{price_total}00").format
    Lote.update(params[:id].to_i, :precio_u => lote_price[:unit_price], :precio_t => price_total, :respon_edicion_id => current_user)
    @prices = {:total => format_price_t, :unit => format_price_u}
    respond_to do |format|
      format.json{render json: @prices}
    end
  end
  # -------------------------------------------------------------------------#
  # Métodos privados
  private
    # Use callbacks to share common setup or constraints between actions.
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
    
    def set_programing

      Programacion.new_old_programacion 
    end

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
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def lote_params
      sub_id_value
      params.require(:lote).permit(:empresa, :color_prenda, :programacion_id,
        :no_remision, :no_factura, :cliente_id, :tipo_prenda_id, :prioridad, 
        :op, :fecha_entrada,  :fin_insumos, :obs_insumos, :meta, :h_req, 
        :obs_integracion, :fin_integracion, :cantidad, :precio_u, :precio_t,
        :fecha_revision, :fecha_entrega, :control_lotes_attributes => [:id, 
          :sub_estado_id, :lote_id, :fecha_ingreso, :fecha_salida, :estado_id, :_destroy],
          :colores_lotes_attributes => [:id, :color_id, :lote_id, :total_id, :_destroy, 
            :cantidades_attributes =>[:id, :categoria_id, :total_id, :cantidad, :_destroy]]).
      merge(respon_edicion_id: current_user, referencia_id: set_referencia)
    end
    
    # Parámetros para solo guardar actualizaciones para la ficha del lote
    def lote_params_u
      sub_id_value
      params.require(:lote).permit(:empresa, :color_prenda, :programacion_id,
        :no_remision, :no_factura, :fin_insumos, :obs_insumos, 
        :obs_integracion, :fin_integracion, :precio_u,  :meta, :h_req,
        :cliente_id, :tipo_prenda_id, :prioridad, :op, :fecha_entrada,
        :fecha_revision, :fecha_entrega,:cantidad,  :precio_t, :programacion,
        :colores_lotes_attributes => [:id, :color_id, :lote_id, :total_id, :_destroy, 
          :cantidades_attributes =>[:id, :categoria_id, :total_id, :cantidad, :_destroy]]).
      merge(respon_edicion_id: current_user, referencia_id: set_referencia)
    end
    
    def sub_id_value
      if !params[:lote][:control_lotes_attributes].nil?
        if params[:lote][:control_lotes_attributes][:'0'][:sub_estado_id] == ""
          params[:lote][:control_lotes_attributes][:'0'][:sub_estado_id] = "0"
        end
      end
    end

    def referencia_params
      params.require(:lote).permit(:referencia)
    end

    # Método con gon para poder usar el rol desde los coffeescripts
    def rol_user
      if user_signed_in?
        @rol_form = nil
        rol = current_user.roles
        (rol).each do |s|
          @rol_form = s.name
        end
      end
    end
  end