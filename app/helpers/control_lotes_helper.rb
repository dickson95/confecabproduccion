module ControlLotesHelper
	# Sub proceso del historial
	# sub_process(id_sub_proceso)
	def sub_process(sub_process)
		if !sub_process.nil?
			@sub_estado[sub_process.id].upcase
		end
	end

	# Responsable de salida del proceso
	# respon_exit(id_responsable)
	def respon_exit(respon_exit)
		if respon_exit
			@user[respon_exit.id]
		end
	end


	def days(day1, day2)
		if !day2.nil?
			ControlLote.date_operated(day1, day2)[:days]
		else
			"-"
		end
	end

	def set_colspan(pref)
		if !can?(:update, ControlLote)
			pref -= 1
		end
		if !can?(:destroy, ControlLote)
			pref -= 1
		end
		return pref
	end

	def fecha_ingreso_input
		return @control_lote.fecha_ingreso_input if !@control_lote.nil?
    Time.zone.utc_to_local(Time.new) + 60
	end

	# wip_tracing: Definir si el campo para modificar la cantidad en este proceso debe o no aparecer
	def wip_tracing(control_lote)
		@control_lote = control_lote
		if control_lote.estado_id > 3
			form_cantidades
		else
			"<span>#{control_lote.cantidad_last}</span>".html_safe
		end
	end

	private

	def form_cantidades
		render partial: "seguimientos/form"
	end
end
