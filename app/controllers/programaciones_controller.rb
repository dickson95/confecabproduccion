class ProgramacionesController < ApplicationController
	before_action :set_meses
	def index
		@years = Programacion.years_db
		set_programaciones
	end


	# Consultar las programaciones por mes y crear si es necesario
	# POST /program_table/:month
	def program_table
		# Existe o no progrmación para el mes del parámetro
		desicion = Programacion.new_old_programacion params[:month]

		if desicion
			# date_split retorna un hash con el año y el mes
			date = Programacion.date_split params[:month]

			# Fecha con la que se va a generar la programación
			timelocal = Time.local(date[:year], date[:month])

			# Crear la programación para el mes seleccionado
			programacion = Programacion.new(:mes => timelocal)
			if programacion.save
				respond_to do |format|
					format.js
				end
			end
		end
		# Consulta usada para imprimir en la vista independiente de si es vieja o nueva la
		# programación
		set_programaciones
		if @programaciones.empty?

			# Consultar si hay lotes que necesiten incluirse en una programación y en estado de integración
			@no_empty_program = Programacion.lotes_for_program
			if @no_empty_program
				@programacion = Programacion
				.where("extract(year_month from programaciones.mes) = ?", params[:month])
				.pluck(:id)
			end
		end
	end

	# Generar la programación
	# POST /generate_program/:id
	def generate_program
		# Actualizar los lotes con programación id null y estado de integración
		Lote.joins(:control_lotes)
			.where("programacion_id IS NULL and control_lotes.estado_id = 2")
			.update(:programacion_id => params[:id])
		# Establecer las programaciones
		set_programaciones
		respond_to do |format|
			format.js
		end
	end

	private
		def set_meses
			@meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
		end
		def set_programaciones
			# Consulta necesaria para cargar todas las instancias de las vistas exstentes
			@programaciones = Programacion.joins(lotes: [:cliente, :tipo_prenda, :referencia])
			.where("extract(year_month from programaciones.mes) = ?",  params[:month])
			.pluck("clientes.cliente", "tipos_prendas.tipo", "lotes.secuencia", "referencias.referencia", 
				"lotes.cantidad", "lotes.precio_u", "lotes.precio_t", "lotes.meta", "lotes.h_req")
		end
end
