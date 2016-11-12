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
		if !respon_exit.nil?
			@user[respon_exit.id]
		end
	end

	# Formato de fecha
	# format_date(parametro_fecha)
	def range_date(date1, date2)
		if !date2.nil?
			with_month = nil
			if date1.strftime("%m") == date2.strftime("%m")
				with_month = l(date1, :format => "%d")
			else
				with_month = l(date1, :format => "%d de %b")
			end
			"#{with_month} - #{l(date2, :format => "%d de %b")}"
		else
			"#{l(date1, :format => "%d de %b")}"
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
end
