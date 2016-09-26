class ProgramacionesController < ApplicationController
	before_action :set_meses, except: [:modal_open]
	before_action :programacion_id, except: [:modal_open]
	before_action :set_programaciones, only: [:index, :export_excel, :export_pdf]
	before_action :no_empty_program, except: [:modal_open, :remove_from_programing, :add_lotes_to_programing]
	
	def index
		programacion = Programacion.set_year_program params[:empresa], params[:month]
		@years = Programacion.years_db
		if programacion
			programacion_id
		end
	end


	# Consultar las programaciones por mes y crear si es necesario
	# si hace falta, no combinarlo con otras funciones.
	# POST /program_table/:month
	def program_table
		programacion  = Programacion.set_year_program params[:empresa], params[:month]
		if programacion
			respond_to do |format|
				format.js
			end
		end
		set_programaciones
	end

	# Generar la programación
	# POST /generate_program/:id
	def generate_program
		# Actualizar los lotes con programación id null
		Lote.where("programacion_id IS NULL and empresa = ?", params[:empresa])
			.update(:programacion_id => params[:id])
		# Establecer las programaciones
		set_programaciones
		respond_to do |format|
			format.js
		end
	end

	# Abrir ventana modal para poder añadir lotes a la programación
	def modal_open
		@lotes_to_program = Lote.joins(:referencia)
								.where("lotes.programacion_id IS NULL and lotes.empresa = ?", 
									params[:empresa])
								.pluck("lotes.id", "referencias.referencia")
		@programacion = params[:month]
		respond_to do |format|
			format.js
		end
	end

	# Relacionar los lotes con la programación
	def add_lotes_to_programing
		@lotes = Array.new
		if !params[:lotes].nil?
			params[:lotes].each do |lote|
				lote = Lote
				.where(:id => lote)
				.update(:programacion_id => @programacion.fetch(0))
				@lotes.push lote
			end
		end
		set_programaciones
		no_empty_program
		respond_to do |format|
			format.js{render "modal_open"}
		end		
	end

	# Remover uno o varios lotes de la programación
	def remove_from_programing
		puts params[:commit]
		if params[:commit] == "Retirar"
			@lotes = Array.new
			if !params[:lotes].nil?
				params[:lotes].each do |lote|
					Lote
					.where(:id => lote)
					.update(:programacion_id => nil)
					@lotes.push lote
				end
			end
		elsif params[:commit] == "Ordenar"
			if !params[:secuencia].nil?
				params[:secuencia].each do |k, v|
					sec = nil
					v.each do |k2, v2|
						if sec.nil?
							sec = v2
						else
							Lote.where(:id => v2.to_i).update(:secuencia => sec.to_i)
						end
					end
				end				
			end
			# Dejar la variable nil para que se pueda escribir la tabla
		end

		set_programaciones
		no_empty_program
		respond_to do |format|
			format.js
		end	
	end

	# Exportar archivos a excel 
	def export_excel
	    respond_to do |format|
      		format.xlsx
    	end
	end

	# Exportar archivos a PDF
	def export_pdf
		respond_to do |format|
			format.pdf do
			   render :pdf => "export_pdf",
		      :disposition => "inline",
		      :orientation => 'Landscape',
		      :template => "programaciones/programacion.pdf.erb",
		      :layout => "layout_pdf.html.erb"
			end 
		  format.html
	    end
	end

	private
		def set_meses
			@meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
		end

		def set_programaciones
			# Consulta necesaria para cargar todas las instancias de las vistas exstentes
			@programaciones = Programacion.joins(lotes: [:cliente, :tipo_prenda, :referencia])
			.where("extract(year_month from programaciones.mes) = ? and lotes.empresa = ?",  params[:month], params[:empresa])
			.order("lotes.secuencia asc")
			.pluck("clientes.cliente", "tipos_prendas.tipo", "lotes.secuencia", "referencias.referencia", 
				"lotes.cantidad", "lotes.precio_u", "lotes.precio_t", "lotes.meta", "lotes.h_req",
				"lotes.id")
		end

		def programacion_id
			# Consultar id de la programación para el enlace de generar la programación
			# en _table_body.html.erb y para imprimir la primera vez en el index
			empresa = params[:empresa] == "CAB" ? true : false
			@programacion = Programacion
				.where("extract(year_month from programaciones.mes) = ? and empresa = ?", 
				params[:month], empresa)
				.pluck(:id)
		end

		def no_empty_program
			@no_empty_program = Programacion.lotes_for_program params[:empresa]
		end

		def new_programacion
			@new_programacion = Lote.new			
		end

end
