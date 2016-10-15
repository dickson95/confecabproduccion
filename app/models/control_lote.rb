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
  def name
    self.estado
  end
  def name
    self.lote.referencia.referencia
  end

  def self.hash_ids
    result = ControlLote.select("lote_id, fecha_ingreso").where("control_lotes.fecha_ingreso = (SELECT MIN(fecha_ingreso) FROM control_lotes cl GROUP BY lote_id HAVING cl.lote_id = control_lotes.lote_id)")
    hash_ids = Hash.new
    result.each do |r|
      hash_ids[r.lote_id] = r.fecha_ingreso
    end
    return hash_ids
  end
end
