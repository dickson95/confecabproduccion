module ProgramacionesHelper
	def colspan
		if can?(:update, Programacion) && can?(:prices, Programacion)
			4
		else
			2
		end
	end

	# Formar estructura de títulos para el archivo de excel
	def titles_head
  	export = params[:export]
		result = ["Orden de trabajo","Ingreso","Proceso", "Cliente", "Referencia", "OP", "Cant"]
		result.push("Pre. Unitario") if export[:precio_u] == "1"
    result.push("Pre. Total") if export[:precio_t] == "1"
    if export[:processes] == "1"
    	result.push "WIP Ingreso"
  		result.push "WIP Integración"
  		result.push "WIP Confección"
  		result.push "WIP Terminación"
  		result.push "WIP Completado"
  		if export[:processes_details].eql?("true")
	  		@lotes_sub_estados.each do |sub_estado|
	  			result.push sub_estado.name.capitalize
	  		end
  		elsif export[:processes_details].eql?("false")
    		result.push "WIP Procesos externos"
  		end
    end
    return result
	end

	# Formar estructura de cuerpo para el archivo de excel
  def set_row_programacion_lote(lote)
  	export = params[:export]
    result = Array.new
    result.push(lote.secuencia)
    result.push(I18n::localize(lote.created_at, format: "%d/%b/%Y"))
    result.push(lote.control_lotes.last.estado.name)
    result.push(lote.cliente.name)
    result.push(lote.referencia.name)
    result.push(lote.op)
    result.push(lote.cantidad)
    result.push(Money.new("#{lote.precio_u}00").format) if export[:precio_u] == "1"
    result.push(Money.new("#{lote.precio_t}00").format) if export[:precio_t] == "1"
    if export[:processes] == "1"
    	hs = set_wip lote
    	result.push hs[1]
  		result.push hs[2]
  		result.push hs[3]
  		result.push hs[4]
  		result.push hs[5]
  		if export[:processes_details].eql?("true")
  			hs = set_wip_external lote
  			@lotes_sub_estados.each do |sub_estado|
  				result.push hs[sub_estado.id]
  			end
  		elsif export[:processes_details].eql?("false")
    		result.push(sum_amount_external_processes(lote))
  		end
    end
    return result
  end

  private

	  def set_wip(lote)
	  	controles = lote.control_lotes
	  	e1 = true; e2 = true; e3 = true; e4 = true; e5 = true
	  	hs = {1 => "0", 2 => "0", 3 => "0", 4 => "0", 5 => "0"}
	  	controles.each do |control|
	  		if control.sub_estado_id.eql?(0)
	    		(hs[1] = control.cantidad; e1 = false) if control.estado_id.eql?(1) && e1
	    		(hs[2] = control.cantidad; e2 = false) if control.estado_id.eql?(2) && e2
	    		(hs[3] = control.cantidad; e3 = false) if control.estado_id.eql?(3) && e3
	    		(hs[4] = control.cantidad; e4 = false) if control.estado_id.eql?(4) && e4
	    		(hs[5] = control.cantidad; e5 = false) if control.estado_id.eql?(5) && e5
	    	end
	  	end
	  	return hs
	  end

	  def set_wip_external(lote)
	  	controles = lote.control_lotes.where("sub_estado_id > 0")
	  	hs = Hash.new
	  	@lotes_sub_estados.each do |sub_estado|
	  		hs[sub_estado.id] = "0"
	  	end
	  	controles.each do |control|
	  		if hs.include? control.sub_estado_id
	  			hs[control.sub_estado_id] = control.cantidad
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
