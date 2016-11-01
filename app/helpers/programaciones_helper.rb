module ProgramacionesHelper
	def manage(rol)
		return rol == "coor_tiempos" || rol == "admin" ? true : false
	end 
	
	def monthly_target(month)
		Programacion
		.where("EXTRACT(year_month from mes)=? and empresa = ?", month, session[:selected_company])
		.pluck("meta_mensual").first.to_i
	end
end
