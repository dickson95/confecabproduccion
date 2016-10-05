module ProgramacionesHelper
	def manage(rol)
		return rol == "coor_tiempos" || rol == "admin" ? true : false
	end
end
