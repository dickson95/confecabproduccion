class LotesController < ApplicationController
  
  # Acciones primarias
  before_action :set_color, only: [:create, :update]
  before_action :set_tipo_prenda, only: [:new, :edit]
  before_action :referencia_params, only: [:set_referencia]
  before_action :set_lote, only: [:show, :edit, :update, :destroy]
  before_action :set_lote_u, only: [:view_datails]
  before_action :set_talla, only: [:view_datails, :new, :edit, :create, :update]
  
  # Validación de autorización
  load_and_authorize_resource :except  => [:view_datails]
  
  # Autocompletado
  autocomplete :color, :color
  
  # GET /lotes
  # GET /lotes.json
  def index
    @lotes = ControlLote.pluck(:lote_id).uniq
    # ControlLote.find(@lotes) # Hacer una consulta con los datos que toma @lotes
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
  
  
  # GET /lotes/1
  # GET /lotes/1.json
  def show
    @control_lotes = ControlLote.all
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
=begin
    respond_to do |format|
      format.js{render 'ajaxResults'}
      format.html
    end
=end
  end
  

  # POST /lotes
  # POST /lotes.json
  def create
    @lote = Lote.new(lote_params)
    puts @lote
    respond_to do |format|
      
      if @lote.save
        @lote = ControlLote.last
        ControlLote.where(:id => @lote.id).update(resp_ingreso_id: current_user)  
        format.html{ redirect_to lotes_path }
      else
        set_tipo_prenda
        if @remove
          @colores_lotes = @lote.colores_lotes.build
          (0..8).each{|n| @cantidades = @colores_lotes.cantidades.build } 
        end
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
    est_id = params[:lote][:control_lotes_attributes][:'0'][:estado_id]
    if lote.fetch(0) == est_id.to_i
      # Id del subestado en variable sub_id
      sub_id = params[:lote][:control_lotes_attributes][:'0'][:sub_estado_id]
      if sub_id == ""
        sub_id = 0
      end
      if lote.fetch(3) != sub_id.to_i
        boolean = true
      end
    else
      boolean = true
    end
    
    # Actualizar fecha salida, responsable de salida, minutos del historial
    if boolean
      puts "actualización de usuario de salida, tiempo y demás"
      time = Time.new()
      updated = ControlLote.where(:id => lote.fetch(2)).update(fecha_salida: time)
      #Método de minutos
      $up
      updated.each{|u| $up = u.fecha_salida}
      min = Lote.minutos_proceso(lote.fetch(1), $up)
      ControlLote.where(:id => lote.fetch(2)).update(min_u: min,
      resp_salida_id: current_user)
    end
    # Respuesta a la solicitud de actualización
    respond_to do |format|
      
      if @lote.update(boolean ? lote_params : lote_params_u )
        if boolean
          ult = ControlLote.last
          ControlLote.where(:id => ult).update(resp_ingreso_id: current_user, 
          fecha_salida: est_id == "5" ? time : nil, resp_salida_id: est_id == "5" ? current_user : nil)
        end
        format.html{ redirect_to lotes_path }
        flash[:success] = "Lote actualizado correctamente"
      else
        format.js { render 'ajaxResultsValidates' }
        format.json { render json: @lote.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # Pasar entre los distintos estados del lote y registrar las fechas de salida
  # de un estado, la de entrada al siguiente y un responsable por acción
  def cambio_estado
    time = Time.new()
    #Actualización de fecha para el último estado
    id = ControlLote.where(["lote_id=?", params[:id]]).maximum(:id)
    ControlLote.where(:id => id).update(fecha_salida: time)
    lote = ControlLote.find(id)
    #método de minutos
    min = Lote.minutos_proceso(lote.fecha_ingreso, lote.fecha_salida)
    
    ControlLote.where(:id => id).update(min_u: min, 
    resp_salida_id: current_user)
    estado = 0
    men = nil
    case params[:btn]
      when '2' # integrar
        estado = 2
        men = "integración"
      when '3' # confeccionar
        estado = 3
        men = "confección"
      when '4' # terminar
        estado = 4
        men = "terminación"
      when '5' # completar
        estado = 5
        men = "completado"
    end
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
  end
  
  # DELETE /lotes/1
  # DELETE /lotes/1.json
  def destroy
    @lote.destroy
    respond_to do |format|
      format.html { redirect_to lotes_url }
      flash[:success] = "Registro eliminado con éxito."
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lote
      @lote = Lote.find(params[:id])
    end
    def set_tipo_prenda
      @tipos_prendas = TipoPrenda.all
      @clientes = Cliente.all
      @sub_estados = SubEstado.all
    end
    
    def set_lote_u
      @lote = ControlLote.where(lote_id: params[:id]).max
    end
    
    def set_talla
      @tallas = Talla.all
    end
    
    def set_referencia
      id = 0
      Referencia.where(:referencia => params[:lote][:referencia]).limit(1).each do |r|
        id = r.id
      end
      
      # Si la referencia no existe se crea una referencia nueva
      if id == 0
        ref = Referencia.new(referencia_params)
        ref.save
        Referencia.where(:referencia => params[:lote][:referencia]).limit(1).each do |r|
          id = r.id
        end
      end
      id
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
      @remove = false
      @colores = Array.new
      @totales = Array.new
      @totales_tallas = Array.new
      params[:lote][:colores_lotes_attributes].each do |k, v| 
        @colores.push v[:color_id]
        puts v[:total_id]
        @totales.push v[:total_id]

        if recorrer_una
          v[:cantidades_attributes].each do |k2, v2|
            @totales_tallas.push v2[:total_id]
          end
          recorrer_una = false
        end
      end
      
      # Decisión para retirar o no el array del color, retira los colores que no tienen
      # descripción
      # col_bool = params[:lote][:colores_lotes_attributes].reject!{|k, v| v[:color_id]==""}
      
      # if !col_bool.empty?
      params[:lote][:colores_lotes_attributes].each do |k, v|
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
        # de 0, es decir, máximos se encuentran 8 ceros
        if cont < 8
          color_id = Color.find_or_create_by(:color =>
          params[:lote][:colores_lotes_attributes][:"#{k}"][:color_id])
          v['color_id'] = color_id.id
          
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
          params[:lote][:colores_lotes_attributes].delete(k)
          @remove = true
        end  
      end
      # end
      #Rails.logger.info("PARAMS: #{params.inspect}")
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def lote_params
      params.require(:lote).permit(:empresa, :color_prenda, 
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
      params.require(:lote).permit(:empresa, :color_prenda, 
      :no_remision, :no_factura, :fin_insumos, :obs_insumos, 
      :obs_integracion, :fin_integracion, :precio_u,  :meta, :h_req,
      :cliente_id, :tipo_prenda_id, :prioridad, :op, :fecha_entrada,
      :fecha_revision, :fecha_entrega,:cantidad,  :precio_t,
      :colores_lotes_attributes => [:id, :color_id, :lote_id, :total_id, :_destroy, 
      :cantidades_attributes =>[:id, :categoria_id, :total_id, :cantidad, :_destroy]]).
      merge(respon_edicion_id: current_user, referencia_id: set_referencia)
    end
    
    def referencia_params
      params.require(:lote).permit(:referencia)
    end
end