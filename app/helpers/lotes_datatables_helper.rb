
module LotesDatatablesHelper
  def data_tables(params)
    arrays = array_data(params)
    company = session[:selected_company] ? "CAB" : "D&C"
    {
        "draw": params[:draw],
        "recordsTotal": Lote.where(:empresa => company).count,
        "recordsFiltered": Lote.where(:empresa => company).count,
        "data":  arrays
    }
  end

  def array_data(params)
    tipos_prendas = TipoPrenda.hash_ids
    lotes = data(params)
    array = Array.new
    lotes.each do |lote|
      array.push(
          [
             lote.fetch(0),
             (view_context.render partial: "dropdown_options", locals:{ lote_id: lote.fetch(0), estado_id: lote.fetch(6) }, formats: :html),
             lote.fetch(1),
             lote.fetch(2),
             lote.fetch(3),
             lote.fetch(4),
             tipos_prendas[lote.fetch(5)],
             Money.new("#{lote.fetch(6)}00").format,
             Money.new("#{lote.fetch(7)}00").format
          ]
      )
    end
    array
  end

  def data(params)
    company = session[:selected_company]
    Lote.joins([control_lotes: [:estado]], :referencia, :cliente)
        .where("control_lotes.fecha_ingreso = (SELECT MAX(fecha_ingreso) FROM control_lotes
        cl GROUP BY lote_id HAVING cl.lote_id = control_lotes.lote_id) and lotes.empresa = '#{company ? "CAB" : "D&C"}'")
        .limit(params[:length]).offset(params[:start]).order("lotes.id desc")
        .pluck("lotes.id", "clientes.cliente", "referencias.referencia", "lotes.op", "lotes.cantidad",
               "lotes.tipo_prenda_id", "lotes.precio_u", "lotes.precio_t")
  end
end