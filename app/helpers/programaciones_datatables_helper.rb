module ProgramacionesDatatablesHelper
  include ProgramacionesHelper
  def data_tables(params)
    @params ||= params
    @company = session[:selected_company]
    {
        data: array
    }
  end

  def array
    @lotes = data
    array = []
    @lotes.each do |lote|
      array.push row(lote)
    end

  end

  def row(lote)
    row = []
    lote_id =  lote.id
    if can? :update, Programacion
      row.push(view_context.render partial: "checkbox", locals: {lote_id: lote_id}, formats: :html)
    end
    row.push(view_context.render partial: "lotes/dropdown_options", locals:{ lote_id: lote_id, estado_id: lote.control_lotes.last.estado_id }, formats: :html)
    row.push(view_context.render partial: "text_field_secuencia", locals: {lote_id: lote_id, secuencia: lote.secuencia}, formats: :html)
    row.push(estado_or_sub lote_id)
    row.push(lote.cliente.cliente)
    row.push(lote.tipo_prenda.tipo)
    row.push(lote.referencia.referencia)
    row.push(lote.op)
    row.push(lote.cantidad)
    if can? :prices, Lote
      row.push(money lote.precio_u)
      row.push(money lote.precio_t)
    end
    row.push(view_context.render partial: "input_ingresara_a_planta", locals:{lote_id: lote_id, ingresara: lote.ingresara_a_planta}, formats: :html)

  end

  def data
    @params[:action].eql?("index") ? @params[:month] = Time.new.strftime("%Y%m") : nil
    Programacion.where("extract(year_month from mes) = ? and empresa = ?",
                       @params[:month], @company).lotes.order("lotes.ingresara_a_planta asc, lotes.secuencia asc")

  end

end
