
module LotesDatatablesHelper
  def data_tables(params)
    arrays = array_data(params)
    company = session[:selected_company] ? "CAB" : "D&C"
    {
        "draw": params[:draw],
        "recordsTotal": Lote.where(:empresa => company).count,
        "recordsFiltered": arrays[:can],
        "data":  arrays[:a]
    }
  end

  def array_data(params)
    tipos_prendas = TipoPrenda.hash_ids
    clientes = Cliente.hash_ids
    referencias = Referencia.hash_ids
    lotes = data(params)
    array = Array.new
    lotes[:lotes].each do |lote|
      array.push(
          [
             lote.id,
             (view_context.render partial: "dropdown_options", locals:{ lote_id: lote.id, estado_id: lote.control_lotes.last.estado_id }, formats: :html),
             clientes[lote.cliente_id],
             referencias[lote.referencia_id],
             lote.op,
             (view_context.content_tag :span, lote.cantidad, data:{ cantidad: lote.cantidad }),
             tipos_prendas[lote.tipo_prenda_id],
             (view_context.content_tag :input, "", data:{:lote => lote.id}, :value => Money.new("#{lote.precio_u}00").format, :class => "form-control input-sm lote_precio_unitario", :disabled => (can? :prices_update, Lote)? false : true),
             (view_context.content_tag :span, Money.new("#{lote.precio_t}00").format, data:{ total: '0' })
          ]
      )
    end
    {a: array, can: lotes[:amount]}
  end

  def data(params)
    company = session[:selected_company] ? "CAB" : "D&C"
    lotes = nil
    amou = nil
    order_val = params[:order]["0"]
    order = {"0" => {:id => order_val[:dir]}, "2" => {:cliente_id => order_val[:dir]} , "6" => {:tipo_prenda_id =>  order_val[:dir]}}
    if params[:search][:value].strip == ""
      amou = Lote.where(:empresa => company).count
      lotes = Lote.where("lotes.empresa = '#{company}'")
        .limit(params[:length]).offset(params[:start]).order(order[order_val[:column]])
    else
      keys = searchable_columns params[:search][:value].strip
      lotes = Lote.ransack(keys)
      amou = lotes.result.where(:empresa => company).count
      lotes = lotes.result.where(:empresa => company).limit(params[:length]).order(order[order_val[:column]])
    end
    { lotes: lotes, amount: amou }
  end
  
  private

  def searchable_columns(value)
    {
        op_cont: value,
        cantidad_eq: value,
        referencia_referencia_cont: value,
        cliente_cliente_cont: value,
        m: 'or'
    }
  end
end