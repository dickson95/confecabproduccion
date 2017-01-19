=begin
Helper de Programacion
Para más información http://api.rubyonrails.org/classes/ActionController/Helpers.html

Helper enfocado en gran parte en armar la exportación a excel de la programación solicitada
=end
module ProgramacionesHelper

  def colspan
    (can?(:update, Programacion) && can?(:prices, Programacion)) ? 4 : 2
  end

  # Formar estructura de títulos para el archivo de excel
  def titles_head
    export = params[:export]
    # Estas son las culumnas fijas que se presentan en la vista de las programaciones a la hora de exportar el excel
    @result = ["Orden de trabajo", "Ingreso", "Ira a planta", "Proceso", "Cliente", "Referencia", "OP", "Cant"]
    @widths = [7, 11, 11, 11, 11, 15, 11, :auto]
    (@result.push("Pre. Unitario"); @widths.push(11)) if export[:precio_u] == "1"
    (@result.push("Pre. Total"); @widths.push(10)) if export[:precio_t] == "1"
    @wip_width = 15
    @wip_d = 5
    if export[:processes] == "1"
      # Nombres de los estados en la parte superior de las culumnas
      estados_titles
      if export[:processes_details].eql?("true")
        processes_details_true
      elsif export[:processes_details].eql?("false")
        processes_details_false
      end
      if export[:reprocess].eql?("true")
        reprocess
      end
    end
    {row: @result, width: @widths}
  end

  # Formar estructura de cuerpo para el archivo de excel
  # @estados: Variable declarada en el archivo export_excel.xlsx
  def set_row_programacion_lote(lote)
    export = params[:export]
    @result = Array.new
    @result.push(lote.secuencia)
    @result.push(I18n::localize(lote.created_at, format: "%d/%b/%Y"))
    @result.push(set_date(lote.ingresara_a_planta, "%d/%b/%Y"))
    @result.push(lote.control_lotes.last.estado.name)
    @result.push(lote.cliente.name)
    @result.push(lote.referencia.name)
    @result.push(lote.op)
    @result.push(lote.cantidad)
    @result.push(money lote.precio_u) if export[:precio_u] == "1"
    @result.push(money lote.precio_t) if export[:precio_t] == "1"
    # Exportar los procesos adicionales
    if export[:processes] == "1"
      estados_row lote
      # Si se quiere el detalle del wip en la exportación
      if export[:processes_details].eql?("true")
        # Paso un lote para determinar los procesos externos
        processes_details_true_row(lote)
      elsif export[:processes_details].eql?("false")
        @result.push(sum_amount_external_processes(lote))
      end
      if export[:reprocess].eql?("true")
        reprocess_row(lote)
      end
    end
    @result
  end

  def monthly_target(month)
    Programacion.where("EXTRACT(year_month from mes)=? and empresa = ?", month, session[:selected_company])
        .pluck("meta_mensual").first.to_i
  end

  private

  # Títulos del informe de los estados.
  # @estados: Variable declarada en el archivo export_excel.xlsx
  # @result: Variable declarada en el método titles_head
  # @widths: Variable declarada en el método titles_head
  def estados_titles
    @estados.each do |estado|
      e = estado.name.downcase
      @result.push("Entrada #{e}"); @widths.push(@wip_width)
      @result.push("Salida #{e}"); @widths.push(@wip_width)
      @result.push("WIP #{e}"); @widths.push(@wip_d)
      @result.push("Cant #{e}"); @widths.push(@wip_d)
    end
  end

  def estados_row(lote)
    hs = set_wip lote
    cont = 1
    @estados.each do |estado|
      control = hs[estado.id]
      @result.push(control[:entry])
      @result.push(control[:output])
      @result.push(control[:days])
      @result.push(control[:value])
      cont += 1
    end
  end

  # Títulos del informe de los detalles de procesos.
  # @lotes: Variable declarada en el controlador
  # @result: Variable declarada en el método titles_head
  # @widths: Variable declarada en el método titles_head
  def processes_details_true
    @lotes_sub_estados.each do |sub_estado|
      @result.push(sub_estado.name.capitalize); @widths.push(15)
      @result.push(""); @widths.push(5)
    end
  end

  def processes_details_true_row(lote)
    hs = set_wip_external lote
    @lotes_sub_estados.each do |sub_estado|
      @result.push hs[sub_estado.id][:date]
      @result.push hs[sub_estado.id][:amount]
    end
  end

  # Títulos del informe de los procesos externos.
  # @result: Variable declarada en el método titles_head
  # @widths: Variable declarada en el método titles_head
  def processes_details_false
    @result.push("WIP-Procesos externos"); @widths.push(@wip_width)
  end

  # Títulos del informe de los reprocesos.
  # @result: Variable declarada en el método titles_head
  # @widths: Variable declarada en el método titles_head
  def reprocess
    # Retorn la cantidad de grupos de reprocesos que hay. Esto determina cuantas columnas para reprocesos se pintan
    max = count_reprocess
    for n in 1..max
      puts "recorrido #{n}"
      @result.push("Reproceso #{n} desde"); @widths.push(@wip_width)
      @result.push("Reproceso #{n} hacia"); @widths.push(@wip_width)
      @result.push("Reproceso #{n} cant"); @widths.push(@wip_d)
      @result.push("Reproceso #{n} fecha"); @widths.push(@wip_width)
    end
  end

  # Filas del informe de los reprocesos
  def reprocess_row(lote)
    @lote = lote
    @lote.control_lotes.each do |control|
      control.seguimientos.where("seguimientos.proceso": false, "seguimientos.reproceso": true).each do |seguimiento|
        puts "id seguimiento actual #{seguimiento.id}, id previo #{seguimiento.prev.id}"
        puts "cantidad en seguimiento #{seguimiento.cantidad }, seguimiento anterior #{seguimiento.prev.cantidad}"
        puts "cantidad restada #{seguimiento.cantidad - seguimiento.prev.cantidad}"
        control.id
        $next = ControlLote.next(control)
        @result.push($next.estado.name.downcase)
        @result.push(seguimiento.control_lote.estado.name.downcase)
        @result.push(seguimiento.cantidad - seguimiento.prev.cantidad)
        @result.push(l(seguimiento.created_at, format: "%d de %B"))
      end
    end
  end

  def count_reprocess
    max = 0
    @programacion_lotes.each do |lote|
      # nrep: number of reprocess
      nrep = lote.control_lotes.joins(:seguimientos).where("seguimientos.proceso": false, "seguimientos.reproceso": true).count
      if nrep > max
        max = nrep
      end
    end
    max
  end
  # Establecer valores del los estados, fechas y el wip(cantidad de días)
  def set_wip(lote)
    controles = lote.control_lotes.where(:sub_estado_id => 0).group(:estado_id)
    hs = {}
    # Asignar valor 0 para que en caso de que el estado no exista en el proceso no quede en blanco
    @estados.each do |estado|
      hs[estado.id] = {value: "0", output: "", entry: "", days: "0"}
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
    hs
  end

  def sum_amount_external_processes(lote)
    controles = lote.control_lotes.where("sub_estado_id > 0")
    sum = 0
    controles.each do |control|
      sum += control.cantidad_last
    end
    sum
  end

  def money(object)
    Money.from_amount(object, "COP").format(:no_cents => true)
  end
end
