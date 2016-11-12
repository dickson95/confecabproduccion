class ControlLote < ApplicationRecord
  belongs_to :lote, optional: true
  belongs_to :estado
  belongs_to :sub_estado, optional: true
  belongs_to :resp_ingreso_id, class_name: 'User', foreign_key: 'resp_ingreso_id'
  belongs_to :resp_salida_id, class_name: 'User', foreign_key: 'resp_salida_id', 
  optional: true
  
  # Validaciones
  validates :estado, :fecha_ingreso, presence: true
  
  # Métodos
  
  def sub_estado_id=(val)
    val = val.strip.eql?("") ? "0" : val
    write_attribute(:sub_estado_id, val)
  end

  def self.hash_ids
    result = ControlLote.select("lote_id, fecha_ingreso").where("control_lotes.fecha_ingreso = (SELECT MIN(fecha_ingreso) FROM control_lotes cl GROUP BY lote_id HAVING cl.lote_id = control_lotes.lote_id)")
    hash_ids = Hash.new
    result.each do |r|
      hash_ids[r.lote_id] = r.fecha_ingreso
    end
    return hash_ids
  end

  # Retorna un hash con opciones de la resta de los días
  def self.date_operated(date_initial, date_final)    
    {
      :days => days_absolute(date_initial, date_final)
    }
  end

  private
    # Parametros
    # d1: Día inicial 
    # d2: Dia final
    # return: Días absolutos entre dos fechas
    def self.days_absolute(d1, d2)
      di = d1 + 1.day 
      di = Time.local(di.year, di.month, di.day)
      df = Time.local(d2.year, d2.month, d2.day)
      ((df - di) / (24 * 60 * 60)).ceil + 2
    end
end
