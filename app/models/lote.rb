class Lote < ApplicationRecord
  #Relaciones
  belongs_to :programacion, optional: true
  belongs_to :referencia
  belongs_to :cliente
  belongs_to :tipo_prenda,  optional: true
  belongs_to :respon_insumos_id, class_name: 'User', foreign_key: 'respon_insumos_id', optional: true
  belongs_to :respon_edicion_id, class_name: 'User', foreign_key: 'respon_edicion_id'
  has_many :control_lotes, :dependent => :destroy
  has_many :colores_lotes, :dependent => :destroy
  accepts_nested_attributes_for :control_lotes, allow_destroy: true
  accepts_nested_attributes_for :colores_lotes, allow_destroy: true
  
  #
  #
  #Validaciones
  validates_presence_of :cliente, :control_lotes, :colores_lotes
  validates :referencia, :empresa, presence: true
  
  
  def categorias_colores_for_form
    collection = categorias_colores.where(ave_id: id)
	  collection.any? ? collection : categorias_colores.build
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
  
  # Mètodo de 10/08/2016 
  # Toma un entero y retorna el mismo separado por comas para que se pueda ver 
  # claramente la cantidad expresada en precio.
  def self.str_pesos(num)
    num = num.to_s
    num = num.scan(/./)
    cont = 0
    str = nil
    num.reverse_each do |e|  
    	if cont == 2 
    		e = e+","
    		cont = 0
    	else
    		cont = cont + 1
    	end
    	str = "#{str}#{e}"
    end 
    str = str.reverse
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
end
