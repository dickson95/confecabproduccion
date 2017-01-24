class Lote < ApplicationRecord
  #Relaciones
  belongs_to :programacion, optional: true
  belongs_to :referencia
  belongs_to :cliente
  belongs_to :tipo_prenda
  belongs_to :respon_insumos_id, class_name: 'User', foreign_key: 'respon_insumos_id', optional: true
  belongs_to :respon_edicion_id, class_name: 'User', foreign_key: 'respon_edicion_id'
  has_many :control_lotes, :dependent => :destroy
  has_many :colores_lotes, :dependent => :destroy
  has_and_belongs_to_many :colores

  accepts_nested_attributes_for :control_lotes, allow_destroy: true
  accepts_nested_attributes_for :colores_lotes, allow_destroy: true
  # scopes

  # Trae el estado actual de cada lote
  scope :current_state, -> { joins(:control_lotes).where("control_lotes.fecha_ingreso = (SELECT MAX(fecha_ingreso) FROM control_lotes cl GROUP BY lote_id HAVING cl.lote_id = control_lotes.lote_id)") }
  # En uso con :current_state se puede filtrar por el estado deseado
  scope :state_filtered, ->(state) { joins(:control_lotes).where("control_lotes.estado_id = ?", state) }

  #Validaciones
  validates_presence_of :cliente, :control_lotes, :colores_lotes, 
  :tipo_prenda_id, :referencia, :empresa
  validate :major_date_to_today, :op_uniquenesses
  
  # La op debe ser única, permitir nil, validar por empresa y trabajar con los 
  # campos que antes de esta validación incumplian con el requerimiento
  def op_uniquenesses
    val = Lote.validate_op(op, empresa, id)
    errors.add(:op, "Ya existe esta OP") if !val
  end
  
  # Retorna true en caso de que la op sea válida, caso contrario false
  def self.validate_op(op, empresa, id=nil)
    if op != ""
      # si el id está nil siginifica que es un registro nuevo
      if id.nil?
        $val = Lote.where("op = ? and empresa = ?", op, empresa).pluck(:op)
      else
        $val = Lote.where("op = ? and id <> ? and empresa = ?", op, id, empresa).pluck(:op)
      end
      $val.empty? ? true : false
    else
      true
    end 
  end

  # Validar que la fecha no sea mayor a la de hoy
  def major_date_to_today
    if !fecha_revision.blank? && fecha_revision > Date.today
      errors.add(:fecha_revision, "La fecha no debe ser mayor a hoy")
    end
    if !fecha_entrega.blank? && fecha_entrega > Date.today
      errors.add(:fecha_entrega, "La fecha no debe ser mayor a hoy")
    end
  end


  # Determinar si el lote tiene una programación y puede pasar a la confección
  def self.has_programing(id, estado)
    if (estado.to_i).between?(3, 5)
      lote = Lote.find(id)
      return !lote.programacion_id.nil? ? true : false
    else
      true
    end
  end

  #
  #
  #Métodos
  def name
    if referencia != nil
      self.referencia.referencia
    end
  end
  
  def op=(val)
    self[:op] = val.upcase
  end
  
  def programacion_id=(val)
    self[:programacion_id] = set_programacion(val)
  end

  def set_programacion(val)
    class_val = val.class
    puts class_val
    puts val
    if class_val == Fixnum || class_val == NilClass
      puts "programación"
      return val
    else
      if val.strip != ""
        date = val.split(" ")
        month_number = split_date_on_space(date[0]) 
        Programacion.set_year_program empresa, date[1]+month_number
        empresa_f = empresa == "CAB" ? true : false
        programing = Programacion.where("extract(year_month from programaciones.mes) = ? and programaciones.empresa = ?",
              date[1]+month_number, empresa_f).limit(1)
        return programing[0].id
      else
        return nil
      end
    end  
  end
  
  def self.multiplication(numbers)
    result = 1
    numbers.each do |number|
      result *= number.to_i
    end
    return result
  end

  def self.functional_format(str)
    if /\D/.match(str)
      # Expresión que coincide con el punto del string y cualquier número hacia la derecha que encuentre
      str = str.gsub /[.]\d+/, ''
      # Expresión que coincide con cualquier caracter que no sea numérico
      return str.gsub /\D/,''
    else
      return str
    end
  end
  
  # Definir si existe el valor de la op pero permitiendo valores nulos
  # no se utiliza otro método porque ya existen registros que incumplen la 
  # restricción de unico
  # Retorna true si la op no existe y puede ser creada
  def self.op_exist(op, options={})
    # Opciones por defecto que el método acepta
    default_options = {:action => "",:lote_id => nil} 
    if op != ""
      $val
      if options[:action].eql?("edit") || options[:action].eql?("update")
        $val = Lote.where("op = ? and id <> ?", op, options[:lote_id]).pluck(:op)
      else
        $val = Lote.where(:op => op).pluck(:op)
      end
      return $val.empty? ? true : false
    else
      true
    end
  end

  def self.set_keys_query(hash_keys)
    hash_keys.delete_if { |key, value| value == "0"}
  end  
  
  def self.query_filtered(params, company)
    from = params[:from]
    to = params[:to]
    customer = params[:clientes]
    if !customer.strip.eql?("") && !from.strip.eql?("") && !to.strip.eql?("")
      return Lote.where("empresa = ? AND cliente_id = ? AND created_at BETWEEN ? AND ?", company, customer.to_i, from, to )
    end
    if !from.strip.eql?("") && !to.strip.eql?("")
      return Lote.where("empresa = ? AND created_at BETWEEN ? AND ?", company, from, to )
    end
    if !customer.strip.eql?("")
      return Lote.where("empresa = ? AND cliente_id = ?", company, customer.to_i)
    end
    return Lote.where("empresa = ?", company)
  end
  
  private 
    def split_date_on_space(str)
      @meses = Programacion.meses
      $month
      @meses.each do |k, v|
        if v.has_value?(str)
          $month = v[:number]
          break
        end
      end
      return $month
    end
  
end
