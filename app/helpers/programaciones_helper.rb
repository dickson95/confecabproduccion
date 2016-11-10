module ProgramacionesHelper
	def colspan
		if can?(:update, Programacion) && can?(:prices, Programacion)
			4
		else
			2
		end
	end
end
