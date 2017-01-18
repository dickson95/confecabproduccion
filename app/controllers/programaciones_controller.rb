class ProgramacionesController < ApplicationController
  load_and_authorize_resource
  before_action :empresa
  before_action :set_meses, except: [:modal_open, :update_row_order, :update_meta_mensual]
  before_action :programacion_id, except: [:modal_open, :update_row_order, :export_excel, :update_meta_mensual]
  before_action :states_lotes, only: [:index, :program_table]
  before_action :sum_totals, except: [:modal_open, :update_row_order, :export_excel, :options_export, :update_meta_mensual]
  before_action :set_programaciones, only: [:index, :export_pdf]
  before_action :no_empty_program, except: [:modal_open, :remove_from_programing, :add_lotes_to_programing, :export_excel, :options_export]

  def index
    programacion = Programacion.set_year_program @empresa, params[:month]
    @years = Programacion.years_db
    if programacion
      programacion_id
    end
  end


  # Consultar las programaciones por mes y crear si es necesario
  # GET /program_table/:month
  def program_table
    programacion = Programacion.set_year_program @empresa, params[:month]
    if programacion
      programacion_id
    end
    set_programaciones
    respond_to do |format|
      format.js
    end
  end

  # Generar la programación
  # POST /generate/:id
  def generate
    # Actualizar los lotes con programación id null
    Lote.where("programacion_id IS NULL and empresa = ?", @empresa)
        .update(:programacion_id => params[:id].to_i)
    # Establecer las programaciones
    set_programaciones
    states_lotes
    sum_totals
    respond_to do |format|
      format.js
    end
  end

  # Abrir ventana modal para poder añadir lotes a la programación
  def modal_open
    @lotes_to_program = Lote.joins(:referencia)
                            .where("lotes.programacion_id IS NULL and lotes.empresa = ?",
                                   @empresa)
                            .pluck("lotes.id", "referencias.referencia")
    @programacion = params[:month]
    respond_to do |format|
      format.js
    end
  end

  # recuperara una fila específica de los lotes de la programación
  def get_row
    lote = Lote.find(params[:lote_id])
    this = Programacion
    @programacion = this.where(id: lote.programacion_id)
    states_lotes
    lote_array = this.lote_array(lote)
    row = {partial: (view_context.render partial: "row", locals: {lote: lote_array}, formats: :html)}
    respond_to do |format|
      format.json{ render json: row }
    end
  end

  # Relacionar los lotes con la programación
  def add_lotes_to_programing
    @lotes = Array.new
    if !params[:lotes].nil?
      params[:lotes].each do |lote|
        lote = Lote.where(:id => lote)
                   .update(:programacion_id => @programacion.fetch(0), :respon_edicion_id => current_user)
        @lotes.push Programacion.lote_array(lote.first)
      end
    end
    set_programaciones
    no_empty_program
    states_lotes
    sum_totals
    respond_to do |format|
      format.js { render "modal_open" }
    end
  end

  # Remover uno o varios lotes de la programación
  def remove_from_programing
    if params[:commit] == "Retirar"
      @lotes = Array.new
      if !params[:lotes].nil?
        params[:lotes].each do |lote|
          Lote.where(:id => lote)
              .update(:programacion_id => nil, :secuencia => nil, :ingresara_a_planta => nil, :respon_edicion_id => current_user)
          @lotes.push lote
        end
      end
    elsif params[:commit] == "Ordenar"
      Programacion.sort_manually params[:programacion][:secuencia]
    end
    set_programaciones
    no_empty_program
    states_lotes
    sum_totals
    respond_to do |format|
      format.js
    end
  end


  # Ordenar tabla
  def update_row_order
    programacion_params[:updated_positions].each do |k, v|
      Lote.update(v[:lote_id].to_i, :secuencia => v[:position], :respon_edicion_id => current_user)
    end
    head :no_content # this is a POST action, updates sent via AJAX, no view rendered
  end

  def options_export
    clientes = Lote.distinct.where("programacion_id = ?", @programacion.first).pluck(:cliente_id)
    @clientes = Cliente.select(:id, :cliente).find(clientes)
    @estados = Estado.all
    ids_sub_estados = Lote.joins(:control_lotes).where(:programacion_id => @programacion.first).distinct.where("control_lotes.sub_estado_id > 0").pluck("control_lotes.sub_estado_id")
    @sub_estados = SubEstado.find(ids_sub_estados)
    if params[:format_export].eql?("xlsx")
      @url = export_excel_programacion_path(@programacion.first, :format => "xlsx")
    elsif params[:format].eql?("pdf")
      @url = export_pdf_programaciones_path
    end
  end

  # Exportar archivos a excel
  def export_excel
    @programacion = Programacion.where("extract(year_month from programaciones.mes) = ? and empresa = ?",
                                       export_permit[:month], session[:selected_company])
    @programacion_head = Programacion.find(params[:id])
    # @programacion_lotes = @programacion_head.lotes
    values = Programacion.remove_empty_key_value({
                                                     "cliente" => export_permit[:cliente],
                                                     "control_lotes.estado" => export_permit["control_lotes.estado"],
                                                     "control_lotes.sub_estado" => export_permit["control_lotes.sub_estado"]
                                                 })
    @programacion_lotes = Programacion.collection_lotes @programacion_head, values
    ids_sub_estados = @programacion_head.lotes.joins(:control_lotes).distinct.where("control_lotes.sub_estado_id > 0").pluck("control_lotes.sub_estado_id")
    @lotes_sub_estados = SubEstado.find(ids_sub_estados)
    @date = Programacion.date_split(export_permit[:month])
    render xlsx: "export_excel", filename: "#{@empresa} de #{@meses[@date[:month]][:string]}.xlsx"
  end

  # Exportar archivos a PDF
  def export_pdf
    date = Programacion.date_split(params[:month])
    respond_to do |format|
      format.pdf do
        render :pdf => "#{@empresa} de #{@meses[date[:month]][:string]}",
               :orientation => 'Landscape',
               :template => "programaciones/programacion.pdf",
               :layout => "layout_pdf.html.erb",
               :title => "#{@empresa} de #{@meses[date[:month]][:string]}"
      end
      format.html
    end
  end

  private
  def set_meses
    @meses = Programacion.meses
  end

  def set_programaciones
    params[:empresa] = session[:selected_company] ? "CAB" : "D&C"
    # Consulta necesaria para cargar todas las instancias de las vistas exstentes
    params[:action].eql?("index") ? params[:month] = Time.new.strftime("%Y%m") : nil
    @programaciones = Programacion.joins(lotes: [:cliente, :tipo_prenda, :referencia])
                          .where("extract(year_month from programaciones.mes) = ? and lotes.empresa = ?",
                                 params[:month], @empresa).order("lotes.secuencia asc")
                          .pluck("clientes.cliente", "tipos_prendas.tipo", "lotes.secuencia",
                                 "referencias.referencia", "lotes.cantidad", "lotes.precio_u", "lotes.precio_t",
                                 "lotes.meta", "lotes.h_req", "lotes.id", "lotes.ingresara_a_planta")
  end

  def programacion_id
    params[:action].eql?("index") ? params[:month] = Time.new.strftime("%Y%m") : nil
    # Consultar id de la programación para el enlace de generar la programación
    # en _table_body.html.erb y para imprimir la primera vez en el index
    empresa = session[:selected_company]
    @programacion = Programacion.where("extract(year_month from programaciones.mes) = ? and empresa = ?", params[:month], empresa).pluck(:id)
  end

  def no_empty_program
    @no_empty_program = Programacion.lotes_for_program @empresa
  end

  def new_programacion
    @new_programacion = Lote.new
  end

  def programacion_params
    params.require(:programacion).permit(:secuencia => [], :updated_positions => [:lote_id, :position])
  end

  def export_permit
    params.require(:export).permit(:precio_u, :precio_t, :processes,
                                   :processes_details, :month, :cliente, "control_lotes.estado", "control_lotes.sub_estado")
  end

  # Sumar las horas y el precio total.
  def sum_totals
    @total = Lote.where(:programacion_id => @programacion.first).sum(:precio_t)
    @total = Money.new("#{@total}00", "USD").format
    @cantidades = Lote.where(:programacion_id => @programacion.first).sum(:cantidad)
  end

  def states_lotes
    @estados = Programacion.states_lotes(@programacion.first)
  end

  def empresa
    @empresa = session[:selected_company] ? "CAB" : "D&C"
  end
end
