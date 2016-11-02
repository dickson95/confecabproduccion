module ControlLotesHelper
	# Sub proceso del historial
	# sub_process(id_sub_proceso)
	def sub_process(sub_process)
		if !sub_process.nil?
			@sub_estado[sub_process.id]
		end
	end

	# Responsable de salida del proceso
	# respon_exit(id_responsable)
	def respon_exit(respon_exit)
		if !respon_exit.nil?
			@user[respon_exit.id]
		end
	end

	# Formato de fecha
	# format_date(parametro_fecha)
	def format_date(date)
		if !date.nil?
			l(date, :format => "%d de %b %H:%M ")		
		else
			"-"
		end
	end

	def days(day1, day2)
		if !day2.nil?
			ControlLote.date_operated(day1, day2)[:days]
		else
			"-"
		end
	end
end
