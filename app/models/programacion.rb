class Programacion < ApplicationRecord
  ###
  # Relaciones
  has_many :lotes

  scope :get_per_month, ->(year_month, company) { where("EXTRACT(YEAR_MONTH FROM mes)=? AND empresa = ? ", year_month, company) }

  # Getter and setter
  def name
    self.mes
  end

  ###
  # Métodos del modelo

  # Hash de meses como string y number
  def self.meses
    {
        "01" => {:string => "Enero", :number => "01"},
        "02" => {:string => "Febrero", :number => "02"},
        "03" => {:string => "Marzo", :number => "03"},
        "04" => {:string => "Abril", :number => "04"},
        "05" => {:string => "Mayo", :number => "05"},
        "06" => {:string => "Junio", :number => "06"},
        "07" => {:string => "Julio", :number => "07"},
        "08" => {:string => "Agosto", :number => "08"},
        "09" => {:string => "Septiembre", :number => "09"},
        "10" => {:string => "Octubre", :number => "10"},
        "11" => {:string => "Noviembre", :number => "11"},
        "12" => {:string => "Diciembre", :number => "12"}
    }

  end

  # Hash de los estados de los lotes para reducir el tiempo de carga
  def self.states_lotes(programacion)
    states_arr = Lote.joins([control_lotes: [:estado]]).where("lotes.programacion_id = ?
			and control_lotes.fecha_ingreso = (SELECT MAX(fecha_ingreso) 
			FROM control_lotes cl GROUP BY lote_id HAVING cl.lote_id = control_lotes.lote_id)",
                                                              programacion).pluck("lotes.id", "estados.id", "estados.estado", "estados.color", "estados.color_claro")
    states = Hash.new
    states_arr.each do |e|
      states["#{e.fetch(0)}"] = {id: e.fetch(1), name: e.fetch(2), color: e.fetch(3), color_claro: e.fetch(4) }
    end
    states
  end

  # Método que determina si hay una programación existente para el mes solicitado.
  # Retorna true en caso de no encontrar nada en la consulta
  def self.new_old_programacion (month, empresa)
    $programacion = self.where("extract(year_month from programaciones.mes) = ? and programaciones.empresa = ?",
                               month, empresa)
    boolean = false
    if $programacion.empty?
      boolean = true
    end
    return boolean
  end

  # Retorna un hash con el año y el mes
  def self.date_split(year_month)
    year = year_month[0..3]
    month = year_month[4, 5]
    {:year => year, :month => month}
  end


  # Crea el año y mes en caso de que estos no existan para la programación
  # Retorna true en caso de haber creado una nueva programación
  def self.set_year_program(empresa, month)
    empresa_f = empresa == "CAB" ? true : false
    desicion = self.new_old_programacion month, empresa_f
    if desicion
      # date_split retorna un hash con el año y el mes
      date = self.date_split month

      # Fecha con la que se va a generar la programación
      timelocal = Time.local(date[:year], date[:month], "01")

      # Crear la programación para el mes seleccionado
      programacion = self.new(:mes => timelocal, :empresa => empresa_f)
      programacion.save
    end
  end

  # Establece cuales son los años que hay en la tabla de las programaciones
  def self.years_db
    @years = self.distinct.pluck("extract(year from mes)")
  end

  # Establecer si hay lotes para hacer una nueva programación
  # Retorna true si hay lotes para la programación
  def self.lotes_for_program(empresa)
    lotes_program = Lote.joins(:control_lotes)
                        .where("lotes.programacion_id IS NULL and lotes.empresa = ?",
                               empresa)
                        .distinct().pluck("lotes.id")
    if lotes_program.empty?
      return false
    else
      return true
    end
  end

  # Retorna un array que contiene un campo dos espacios que coinciden
  # y dos que no coinciden de acuerdo con las combinaciones dadas para
  # las programaciones existentes y las vacías
  def self.interfaz (n_e_p, programaciones)
    booleans = Array.new
    if n_e_p == false && !programaciones.empty?
      booleans.push false
      booleans.push true
    elsif n_e_p == false && programaciones.empty?
      booleans.push true
      booleans.push true
    elsif n_e_p && programaciones.empty?
      booleans.push true
      booleans.push false
    else
      booleans.push false
      booleans.push false
    end
  end

  # Roles que pueden ver los precios de la programación
  # Habilita "admin", "gerente", "coor_tiempos"
  def self.price(rol)
    price = false
    if rol == "coor_tiempos" || rol == "admin" || rol == "gerente"
      price = true
    end
  end

  def self.sort_manually(ids)
    ids.each do |k, v|
      Lote.update(k.to_i, :secuencia => v.to_i)
    end
  end

  # Retira de un hash aquellas claves cuyo valor esté vacío
  def self.remove_empty_key_value(hash_)
    hash_.each do |k, v|
      hash_.delete(k) if v.strip.eql?("")
    end
  end

  def self.collection_lotes(programing, values)
    lotes = nil
    if values.include?("control_lotes.estado") || values.include?("control_lotes.sub_estado")
      lotes = programing.lotes.joins(:control_lotes).where(values)
      lotes = lotes.reject { |lote| lote.control_lotes.last.estado_id != values["control_lotes.estado"].to_i } if values.include?("control_lotes.estado")
      lotes = lotes.reject { |lote| lote.control_lotes.last.sub_estado_id != values["control_lotes.sub_estado"].to_i } if values.include?("control_lotes.sub_estado")
    else
      lotes = programing.lotes.where(values)
    end
    return lotes
  end


  # Determinar el porcentaje de avance de cada planta de acuerdo
  # con la programación, medido al 100% en cada caso de terminación o confección
  def self.percentage_planta(month, state, company)
    # Recuperar cantidad de lotes que hay en el estado (state) y programación solicitada
    lotes = state_lotes_amount(month, state, company)
    # Contar cuantos lotes hay en la programación
    programacion = self.select(:id).where("EXTRACT(year_month from mes)=? and empresa = ?", month, company).limit(1) if lotes > 0
    amount = self.find(programacion.first.id).lotes.count if programacion
    # Porcentaje completado para la planta
    res = (lotes.to_f * 100) / amount.to_f
    res = res.nan? ? 0.0 : res
    return res
  end

  # Con el fín de utiliar el mismo archivo de last_rows_table para las filas de la programación este método arma
  # un array que tenga el mismo orden que se utiliza en el query del método del controlador set_programaciones
  def self.lote_array(lote)
    array = []
    array.push(lote.cliente.cliente)
    array.push lote.tipo_prenda.tipo
    array.push lote.secuencia
    array.push lote.referencia.referencia
    array.push lote.cantidad
    array.push lote.precio_u
    array.push lote.precio_t
    array.push lote.meta
    array.push lote.h_req
    array.push lote.id
    array.push lote.ingresara_a_planta
    array
  end

  private

  # Recupera la cantidad de lotes para una programación que están en estado solicitado
  def self.state_lotes_amount(month, estado, company)
    Programacion.joins(lotes: [:control_lotes])
        .where("EXTRACT(year_month from programaciones.mes)=? and
				control_lotes.fecha_ingreso = (SELECT MAX(fecha_ingreso) 
				FROM control_lotes cl WHERE cl.estado_id = ? 
				GROUP BY lote_id HAVING cl.lote_id = control_lotes.lote_id) 
				and programaciones.empresa=?", month, estado, company).count
  end
end
