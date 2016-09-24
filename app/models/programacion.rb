class Programacion < ApplicationRecord
  	###
  	# Relaciones
	has_many :lotes

	###
  	# Métodos del modelo

	# Método que determina si hay una programación existente para el mes solicitado.
	# Retorna true en caso de no encontrar nada en la consulta
	def self.new_old_programacion (month)
		$programacion = self.where("extract(year_month from programaciones.mes) = ?",  month)
		boolean = false 
		if $programacion.empty?
			boolean = true
		end
		boolean
	end


	# Establece cuales son los años que hay en la tabla de las programaciones
	def self.years_db 
		@years = self.distinct.pluck("extract(year from mes)")
	end


	# Retorna un hash con el año y el mes
	def self.date_split(year_month)
		year = year_month[0..3]
		month = year_month[4, 5]
		y_m = {:year => year, :month => month}
	end

	# Establecer si hay lotes para hacer una nueva programación
	# Retorna true si hay lotes para la programación
	def self.lotes_for_program
		lotes_program = Lote.joins(:control_lotes)
							.where("lotes.programacion_id IS NULL")
							.distinct().pluck("lotes.id")
		if lotes_program.empty?
			return false
		else
			return true
		end
	end
end
