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
end
