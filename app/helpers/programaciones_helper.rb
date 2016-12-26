module ProgramacionesHelper

  def colspan
    (can?(:update, Programacion) && can?(:prices, Programacion)) ? 4 : 2
  end

  # Formar estructura de títulos para el archivo de excel
  def titles_head
    export = params[:export]
    result = ["Orden de trabajo", "Ingreso", "Ira a planta", "Proceso", "Cliente", "Referencia", "OP", "Cant"]
    widths = [7, 11, 11, 11, 11, 15, 11, :auto]
    (result.push("Pre. Unitario"); widths.push(11)) if export[:precio_u] == "1"
    (result.push("Pre. Total"); widths.push(10)) if export[:precio_t] == "1"

    if export[:processes] == "1"
      wip_width = 15
      wip_d = 5
      @position = result.size
      result.push("WIP-Ingreso"); widths.push(wip_width)
      result.push(""); widths.push(wip_d)
      result.push("WIP-Integración"); widths.push(wip_width)
      result.push(""); widths.push(wip_d)
      result.push("WIP-Confección"); widths.push(wip_width)
      result.push(""); widths.push(wip_d)
      result.push("WIP-Terminación"); widths.push(wip_width)
      result.push(""); widths.push(wip_d)
      result.push("WIP-Completado"); widths.push(wip_width)
      result.push(""); widths.push(wip_d)
      if export[:processes_details].eql?("true")
        @lotes_sub_estados.each do |sub_estado|
          result.push(sub_estado.name.capitalize); widths.push(15)
          result.push(""); widths.push(5)
        end
      elsif export[:processes_details].eql?("false")
        result.push("WIP-Procesos externos"); widths.push(wip_width)
      end
    end
    {row: result, width: widths}
  end

  # Formar estructura de cuerpo para el archivo de excel
  def set_row_programacion_lote(lote)
    export = params[:export]
    result = Array.new
    result.push(lote.secuencia)
    result.push(I18n::localize(lote.created_at, format: "%d/%b/%Y"))
    result.push(set_date(lote.ingresara_a_planta, "%d/%b/%Y"))
    result.push(lote.control_lotes.last.estado.name)
    result.push(lote.cliente.name)
    result.push(lote.referencia.name)
    result.push(lote.op)
    result.push(lote.cantidad)
    result.push(Money.new("#{lote.precio_u}00").format) if export[:precio_u] == "1"
    result.push(Money.new("#{lote.precio_t}00").format) if export[:precio_t] == "1"
    if export[:processes] == "1"
      hs = set_wip lote
      result.push hs[:d1]
      result.push hs[1]
      result.push hs[:d2]
      result.push hs[2]
      result.push hs[:d3]
      result.push hs[3]
      result.push hs[:d4]
      result.push hs[4]
      result.push hs[:d5]
      result.push hs[5]
      if export[:processes_details].eql?("true")
        # Paso un lote para determinar los procesos externos
        hs = set_wip_external lote
        @lotes_sub_estados.each do |sub_estado|
          result.push hs[sub_estado.id][:date]
          result.push hs[sub_estado.id][:amount]
        end
      elsif export[:processes_details].eql?("false")
        result.push(sum_amount_external_processes(lote))
      end
    end
    return result
  end

  def monthly_target(month)
    Programacion.where("EXTRACT(year_month from mes)=? and empresa = ?", month, session[:selected_company])
        .pluck("meta_mensual").first.to_i
  end

  private
  #Establecer valores del los 5 wip
  def set_wip(lote)
    controles = lote.control_lotes
    e1 = true; e2 = true; e3 = true; e4 = true; e5 = true
    hs = {1 => "0", 2 => "0", 3 => "0", 4 => "0", 5 => "0"}
    controles.each do |control|
      if control.sub_estado_id.eql?(0)
        date_range = control.date_range
        value = control.cantidad
        (hs[1] = value; hs[:d1] = date_range; e1 = false) if control.estado_id.eql?(1) && e1
        (hs[2] = value; hs[:d2] = date_range; e2 = false) if control.estado_id.eql?(2) && e2
        (hs[3] = value; hs[:d3] = date_range; e3 = false) if control.estado_id.eql?(3) && e3
        (hs[4] = value; hs[:d4] = date_range; e4 = false) if control.estado_id.eql?(4) && e4
        (hs[5] = value; hs[:d5] = date_range; e5 = false) if control.estado_id.eql?(5) && e5
      end
    end
    return hs
  end

  # Establecer datos para los wip externos
  def set_wip_external(lote)
    controles = lote.control_lotes.where("sub_estado_id > 0")
    hs = Hash.new
    @lotes_sub_estados.each do |sub_estado|
      hs[sub_estado.id] = {:amount => "0"}
    end
    # De acuerdo con los sub estados asigno los datos para la fila del lote
    # El proceso solo establece uno de los procesos siendo el último registrado quien tiene la cantidad que se asigna
    controles.each do |control|
      if hs.include? control.sub_estado_id
        hs[control.sub_estado_id] = {:amount => control.cantidad}
        hs[control.sub_estado_id] = {:date => control.date_range}
      end
    end
    return hs
  end

  def sum_amount_external_processes(lote)
    controles = lote.control_lotes.where("sub_estado_id > 0")
    sum = 0
    controles.each do |control|
      sum += control.cantidad.nil? ? 0 : control.cantidad
    end
    return sum
  end

end
