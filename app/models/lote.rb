class Lote < ApplicationRecord
  # Ordenar lista de acuerdo al campo de la secuencia

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
  
  #
  #
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

  #Método del 02/08/2016
  # Calcula los minutos de un proceso en cada uno de los estados en los que este
  # puede estar.
  def self.minutos_proceso(f_ingreso, f_salida)
    
    #Si se debe hacer el cálculo para el mismo día de trabajo
    ############################################################################
    # Para este punto no hace falta especificar si es sábado en vista de que 
    # la supervisorá abrirá y cerrara el lote un sábado en el horario de trabajo.
    
    if f_salida.to_date == f_ingreso.to_date
        mt = f_salida - f_ingreso
        puts "mt #{mt}"
        
        if '09:00'.between?(f_ingreso.strftime('%H:%M'), f_salida.strftime('%H:%M')) && 
           '09:14'.between?(f_ingreso.strftime('%H:%M'), f_salida.strftime('%H:%M'))
          puts f_ingreso.strftime('%H:%M')
          puts f_salida.strftime('%H:%M')
          puts "estoy en el rango pedido de desayuno, primer día"
          mt = mt - 900
        end
        if '13:00'.between?(f_ingreso.strftime('%H:%M'), f_salida.strftime('%H:%M')) && 
            '13:14'.between?(f_ingreso.strftime('%H:%M'), f_salida.strftime('%H:%M'))
          puts f_ingreso.strftime('%H:%M')
          puts f_salida.strftime('%H:%M')
          puts "estoy en el rango pedido de almuerzo, primer día"
          mt = mt - 900
        end
        mt = mt/60
        puts "Estos son los minutos totales un solo día #{mt/60}"
        return mt
        #fin algoritmo para primer día de trabajo
    else
      #Inicio si abarca más días
      fch1 = f_ingreso.to_datetime
      
      # Le sumo un día para que el ciclo que sigue me recorra todos los días y no 
      # quede faltando uno.
      fch2 = f_salida.to_datetime + 1.day
      acum = 0
      
      # Se recorren las fechas para, tomar primer día, último e intermedios
      (fch1 ... fch2).each do |date|
        # El método wday, retorna el número del día de la semana [0..6]
        dia = date.wday
        boolean = true
        
        # Si el día que se recorre es sábado o domingo
        sabado = false
        domingo = false
        if dia == 6
          sabado = true
        elsif dia == 0
          domingo = true
        end
        
        
        # Día de ingreso. Día 1
        if dia == f_ingreso.to_datetime.wday
          h_salida = nil
          if sabado
            # Tiempo de salida establecido sin día festivo
            h_salida = Time.new(f_ingreso.strftime('%Y'), f_ingreso.strftime('%m'), 
            f_ingreso.strftime('%d'), 11 , 45, 00, '-05:00')
          else
            h_salida = Time.new(f_ingreso.strftime('%Y'), f_ingreso.strftime('%m'), 
            f_ingreso.strftime('%d'), 15 , 00, 00, '-05:00')
          end
          puts f_ingreso
          puts h_salida
          mt = (h_salida - f_ingreso).to_i
          puts "mt día 1#{mt}"
          if '09:00'.between?(f_ingreso.strftime('%H:%M'), h_salida.strftime('%H:%M')) && 
             '09:14'.between?(f_ingreso.strftime('%H:%M'), h_salida.strftime('%H:%M'))
            
            puts "estoy en el rango pedido de desayuno del día 1"
            mt = mt - 900
          end
          if '13:00 PM'.between?(f_ingreso.strftime('%H:%M'), h_salida.strftime('%H:%M')) && 
            '13:14 PM'.between?(f_ingreso.strftime('%H:%M'), h_salida.strftime('%H:%M'))
            puts "estoy en el rango pedido de almuerzo del día 1"
            mt = mt - 900
          end
          
          puts "Minutos totales primer día #{mt/60}"
          mt = mt/60
          acum = acum + mt
          boolean = false
        end
        
        #día de salida
        if dia == f_salida.to_datetime.wday
          h_inicio = Time.new(f_salida.strftime('%Y'), f_salida.strftime('%m'),
          f_salida.strftime('%d'), 06 , 00, 00, '-05:00')
          puts h_inicio
          puts f_salida
          mt = (f_salida - h_inicio).to_i
          
          if '09:00'.between?(h_inicio.strftime('%H:%M'), f_salida.strftime('%H:%M')) && 
            '09:14'.between?(h_inicio.strftime('%H:%M'), f_salida.strftime('%H:%M'))
            
            puts "estoy en el rango pedido de desayuno último día"
            mt = mt - 900
          end
          
          if '13:00 PM'.between?(h_inicio.strftime('%H:%M'), f_salida.strftime('%H:%M')) && 
            '13:14 PM'.between?(h_inicio.strftime('%H:%M'), f_salida.strftime('%H:%M'))
            print "\n estoy en el rango pedido de almuerzo último día"
            mt = mt - 900
          end
          print "\n Minutos totales último día #{mt/60}\n"
          mt = mt/60
          acum = acum + mt
          boolean = false
        end
        
        
        #resto de días
        if boolean
          if sabado
            acum = acum + 330
          elsif domingo
            acum = acum
          else
            acum = acum + 510
          end
          print "\nMinutos del proceso del día #{date.strftime('%m %d')} \s #{acum}\n"
        end
        print "\nMinutos del proceso de todo el lote \s #{acum}\n"
      end 
      return acum
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
