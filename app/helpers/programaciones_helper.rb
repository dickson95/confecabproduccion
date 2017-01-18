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
      # Nombres de los estados en la parte superior de las culumnas
      @estados.each do |estado|
        e = estado.name.downcase
        result.push("Entrada #{e}"); widths.push(wip_width)
        result.push("Salida #{e}"); widths.push(wip_width)
        result.push("WIP #{e}"); widths.push(wip_d)
        result.push("Cant #{e}"); widths.push(wip_d)
      end
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
    # Exportar los procesos adicionales
    if export[:processes] == "1"
      hs = set_wip lote
      cont = 1
      @estados.each do |estado|
        control = hs[estado.id]
        result.push(control[:entry])
        result.push(control[:output])
        result.push(control[:days])
        result.push(control[:value])
          cont += 1
      end
      # Si se quiere el detalle del wip en la exportación
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
    controles = lote.control_lotes.where(:sub_estado_id => 0).group(:estado_id)
    hs = {}
    # Asignar valor 0 para que en caso de que el estado no exista en el proceso no quede en blanco
    @estados.each do |estado|
      hs[estado.id] = {value: "0", output: "", entry: "", days: "0" }
    end
    controles.each do |control|
      if control.sub_estado_id.eql?(0)
        entry = l(control.fecha_ingreso, format: "%d de %B")
        $output = control.fecha_salida.is_a?(Time) ? l(control.fecha_salida, format: "%d de %B") : nil
        con_hs = hs[control.estado_id]
        con_hs[:value] = control.cantidad_last
        con_hs[:output] = $output || "-"
        con_hs[:entry] = entry
        con_hs[:days] = ControlLote.date_operated(control.fecha_ingreso, control.fecha_salida)[:days] if control.fecha_salida
      end
    end
    hs
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
        hs[control.sub_estado_id] = {:amount => control.cantidad_last}
        hs[control.sub_estado_id] = {:date => control.date_range}
      end
    end
    return hs
  end

  def sum_amount_external_processes(lote)
    controles = lote.control_lotes.where("sub_estado_id > 0")
    sum = 0
    controles.each do |control|
      sum += control.cantidad_last
    end
    return sum
  end

end
