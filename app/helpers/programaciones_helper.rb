module ProgramacionesHelper
	def colspan
		if can?(:update, Programacion) && can?(:prices, Programacion)
			4
		else
			2
		end
	end

  def set_row_programacion_lote(lote)
  	export = params[:export]
    result = Array.new
    result.push(lote.created_at)
    result.push(lote.control_lotes.last.estado.name)
    result.push(lote.secuencia)
    result.push(lote.cliente.name)
    result.push(lote.referencia.name)
    result.push(lote.op)
    result.push(lote.cantidad)
  end

end
