class LotesController < ApplicationController
  
  # Acciones primarias
  before_action :set_color, only: [:create, :update]
  before_action :set_rol, only: [:index, :new, :edit, :update, :create]
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
  end
  
  def view_datails
    respond_to do |format|
      format.js
      format.html
    end
  end
  
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
=begin
    respond_to do |format|
      format.js{render 'ajaxResults'}
      format.html
    end
=end
  end

  # GET /lotes/1/edit
  def edit
    if @lote.colores_lotes.empty?
      @colores_lotes = @lote.colores_lotes.build
      puts "sin colores"
      (0..8).each{|n| @cantidades = @colores_lotes.cantidades.build}
    else
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
    respond_to do |format|
      if @lote.save
        @lote = ControlLote.last
        format.html{ redirect_to lotes_path }
        format.js{ render "ajaxResults" }
      else
        format.js { render 'ajaxResultsValidates' }
        format.json { render json: @lote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lotes/1
  # PATCH/PUT /lotes/1.json
  def update
    #Se consulta si el lote ya tienen este estado dentro de los procesos
    lote = ControlLote.joins(:lote).where(['lote_id=? and estado_id=?', params[:id], 
    params[:lote][:control_lotes_attributes][:'0'][:estado_id]])
    boolean = false
    if lote.empty?
      time = Time.local
      
      #Actualización de fecha para el último estado
      id = ControlLote.where(["lote_id=?", params[:id]]).maximum(:id)
      lote = ControlLote.find(id)
      
      #Método de minutos
      min = Lote.minutos_proceso(lote.fecha_ingreso, time)
      ControlLote.where(:id => id).update(fecha_salida: time, min_u: min,
        resp_salida_id: current_user)
      boolean = true
    elsif (params[:lote][:control_lotes_attributes][:'0'][:sub_estado_id] != "")
      lote_sp = ControlLote.joins(:lote).where(['lote_id=? and estado_id=? and  sub_estado_id=?', params[:lote][:id], 
      params[:lote][:control_lotes_attributes][:'0'][:estado_id],
      params[:lote][:control_lotes_attributes][:'0'][:sub_estado_id]])
      if lote_sp.empty? 
        time = Time.new
      
        #Actualización de fecha para el último estado
        id = ControlLote.where(["lote_id=?", params[:id]]).maximum(:id)
        #Estado a confección. Anteriormente estaba en integración
        lote = ControlLote.find(id)
        #método de minutos
        min = Lote.minutos_proceso(lote.fecha_ingreso, time)
        ControlLote.where(:id => id).update(fecha_salida: time, min_u: min,
        resp_salida_id: current_user)
        boolean = true
      end
    end
    # Respuesta a la solicitud de actualización
    respond_to do |format|
      
      if @lote.update(boolean ? lote_params : lote_params_u )
        if boolean
          ult = ControlLote.last
          ControlLote.where(:id => ult).update(resp_ingreso_id: current_user)
        end
        format.html{ redirect_to lotes_path, notice:"Lote actualizado" }
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
        men = "integración"
      when '5' # completar
        estado = 5
        men = "completado"
    end
    # Asignación de parámetros para el nuevo control a registrar. Responsable
    # por el movimiento
    @control_lote = ControlLote.new(:lote_id => params[:id], :estado_id => estado, 
    :fecha_ingreso => time, :resp_ingreso_id => current_user, :fecha_salida => estado == 5 ? time : nil)
 
    respond_to do |format|
      # Nuevo estado en el historial de los lotes
      if @control_lote.save
        format.html { redirect_to lotes_path, notice: "Lote #{men=="completado" ? men : "cambiado a #{men}"}." }
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
      format.html { redirect_to lotes_url, notice: 'Registro eliminado con éxito.' }
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
      @lote = ControlLote.where(lote_id: params[:id]).order("fecha_ingreso").max
    end
    
    def set_rol
      # Carga de rol
      @rol_form = nil
      rol = current_user.roles
      (rol).each do |s|
        @rol_form = s.name
      end
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
      totales = Array.new
      color_id = nil
      total_cantidades_id = nil
      total_colores_id = nil
      bool = true
      i = 0
      
      # Decisión para retirar o no el array del color 
      col_bool = params[:lote][:colores_lotes_attributes].reject!{|k, v| v[:color_id]==""}
      
      if !col_bool.empty?
        params[:lote][:colores_lotes_attributes].each do |k, v|
          # Con la siguiente linea se eliminan del hash aquellos registros que en 
          # la cantidad no tienen nada. Se estableció el valor el valor por defecto 
          # igual a 0 mientras se encuentra una forma más eficiente
          # v['cantidades_attributes'] = v['cantidades_attributes'].reject{|k2, v2| v2[:cantidad]==""}
          cont = 0
          params[:lote][:colores_lotes_attributes][:"#{k}"][:cantidades_attributes].each do |k2, v2|
            if v2[:cantidad] == "0" && cont < 9
              cont += 1
            else
              break
            end
          end
          puts "Este es contador #{cont}"
          if cont < 8
            color_id = Color.find_or_create_by(:color =>
            params[:lote][:colores_lotes_attributes][:"#{k}"][:color_id])
            v['color_id'] = color_id.id
            
            total_colores_id = Total.find_or_create_by(:total =>
            params[:lote][:colores_lotes_attributes][:"#{k}"][:total_id])
            v['total_id'] = total_colores_id.id
            
            
            
            # Recorrer parámetros de cantidades_attributes para asignar el total real
            
            params[:lote][:colores_lotes_attributes][:"#{k}"][:cantidades_attributes].each do |k2, v2|
              
              if bool
                
                total_cantidades_id = Total.find_or_create_by(:total => 
                params[:lote][:colores_lotes_attributes][:"#{k}"][:cantidades_attributes][:"#{k2}"][:total_id])
                v2['total_id'] = total_cantidades_id.id
                totales.push(v2['total_id'])
                
              else
                
                v2['total_id'] = totales.fetch(i)
                i = i + 1
                
              end
            end
              
              # "bool" es asignada como false para evitar que se repitan las consultas
              # contra la base de datos del ciclo anterior
              bool = false
          else
            puts "Se eliminará colores lotes"
            params[:lote][:colores_lotes_attributes].delete(k)
          end  
        end
      end
        Rails.logger.info("PARAMS: #{params.inspect}")
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def lote_params
      params.require(:lote).permit(:empresa, :color_prenda, 
      :no_remision, :no_factura, :cliente_id, :tipo_prenda_id, :prioridad, 
      :op, :fecha_entrada,  :fin_insumos, :obs_insumos, 
      :obs_integracion, :fin_integracion, :cantidad, :precio_u,
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
      :obs_integracion, :fin_integracion, :precio_u,
      :cliente_id, :tipo_prenda_id, :prioridad, :op, :fecha_entrada,
      :fecha_revision, :fecha_entrega,:cantidad,
      :colores_lotes_attributes => [:id, :color_id, :lote_id, :total_id, :_destroy, 
      :cantidades_attributes =>[:id, :categoria_id, :total_id, :cantidad, :_destroy]]).
      merge(respon_edicion_id: current_user, referencia_id: set_referencia)
    end
    
    def referencia_params
      params.require(:lote).permit(:referencia)
    end
end