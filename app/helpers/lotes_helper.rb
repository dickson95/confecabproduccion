module LotesHelper

  def link_to_add_fields(name, clase = nil, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |colores_lotes_for_form|
      render( partial: association.to_s.singularize + "_fields", locals:{
        f: colores_lotes_for_form, b: true, col:"", total:""})
    end
    link_to name, '', class: "#{clase}", 
    data: { id: id, fields: fields.gsub("\n", "")}, :title => "Más cantidades"
  end

  def date_form_value(lote)
    if !@lote.programacion.nil?
      I18n::localize(@lote.programacion.mes, :format => "%B %Y")
    end
  end

  # Cambio de estados. Las opciones son todas las disponibles en el helper link_to
  def next_state( state )
    men = nil
    state = state.to_i
    case state
      when 1
        men = { :view => 'Integrar', :state => state + 1, :boolean => true }
      when 2
        men = { :view =>'Confeccionar', :controller => "integración", :state => state + 1, :boolean => true }
      when 3
        men = { :view => 'Terminar', :controller => "confección", :state => state + 1, :boolean => true }
      when 4
        men = { :view => 'Completar', :controller => "terminación", :state => state + 1, :boolean => true }
      when 5
        men = { :controller => "completado", :state => state + 1, :boolean => false }
      else
        men = {:state => state, :boolean => false }
    end
    return men
  end

  def def_names(keys)
    names = Array.new
    modify = { 
      no_remision: "Número de remisión",
      no_factura: "Número de factura",
      fecha_revision: "Día revisión de insumos",
      fecha_entrega: "Día entrega de insumos",
      obs_insumos: "Observaciones de los insumos",
      fin_insumos: "Insumos listos",
      referencia_id: "Referencia",
      cliente_id: "Cliente",
      tipo_prenda_id: "Descripción",
      created_at: "Fecha de ingreso",
      precio_u: "Precio unitario",
      precio_t: "Precio total",
      secuencia: "No. de secuencia en programación",
      obs_integracion: "Observaciones de integración",
      fin_integracion: "Integración lista",
      fecha_entrada: "Día recepción de insumos",
      programacion_id: "Programación"
    }
    keys.each do |key| 
      if modify.include? key.to_sym
        names.push modify[key.to_sym]
      else
        names.push key.capitalize
      end
    end
    return names
  end

  def keys_lote(lote)
    p = lote.programacion
    { 
      op: lote.op,
      cantidad: lote.cantidad,
      no_remision: lote.no_remision,
      no_factura: lote.no_factura,
      fecha_revision: lote.fecha_revision,
      fecha_entrega: lote.fecha_entrega,
      obs_insumos: lote.obs_insumos,
      fin_insumos: lote.fin_insumos ? "Sí": "No" ,
      referencia_id: lote.referencia.name,
      cliente_id: lote.cliente.name,
      tipo_prenda_id: lote.tipo_prenda.name,
      created_at: lote.created_at,
      precio_u: Money.new("#{lote.precio_u}00").format,
      precio_t: Money.new("#{lote.precio_t}00").format,
      secuencia: lote.secuencia,
      obs_integracion: lote.obs_integracion,
      fin_integracion: lote.fin_integracion ? "Sí": "No",
      fecha_entrada: lote.fecha_entrada,
      programacion_id: p.nil? ? "No tiene" : p.mes
    }
  end

  # Keys: Atributos que serán exportados
  # Value: Hash de valores de los atributos del lote
  def values_lote(keys, value)
    values = Array.new
    keys.each do |key|
      if value.include? key.to_sym
        values.push(value[key.to_sym])
      end
    end
    return values
  end

  def data_tables(params)
    {
        "draw": params[:draw],
        "recordsTotal": Lote.where(:empresa => "CAB").count,
        "recordsFiltered": 57,
        "data": [
            [
                "Angelica",
                "#{view_context.link_to "lotes", root_path, class: 'btn btn-danger btn-lg'}",
                "System Architect",
                "London",
                "9th Oct 09",
                "$2,875",
                "9th Oct 09",
                "$2,875",
                "$2,875"
            ],
            [
                "Ashton",
                "Cox",
                "Technical Author",
                "San Francisco",
                "12th Jan 09",
                "$4,800",
                "9th Oct 09",
                "$2,875",
                "$2,875"
            ]
        ]
    }
  end
end
