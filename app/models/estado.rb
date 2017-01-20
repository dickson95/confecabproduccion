=begin
Estos son los procesos principales por los que los lotes del sistema van a pasar
Son administrados por un root del sistema y son vitales para el funcionamiento del mismo.
=end
class Estado < ApplicationRecord
  has_many :control_lotes

  #Validaciones
  validates :secuencia, uniqueness: true
  validates :pasa_cantidad, inclusion: {in: [true, false]}
  validates :estado, :nombre_accion, :color, :color_claro, :secuencia, presence: true

  # Get name para los formularios que usan desplegables
  def name
    self.estado.upcase
  end

  def pasa
    self.pasa_cantidad ? "Sí" : "No"
  end

  # Seguimiento anterior
  def prev
    Estado.where("id < ?", self.id).order("secuencia desc").limit(1).first
  end

  # Proceso siguiente
  def next
    Estado.where("id > ?", self.id).order("secuencia asc").limit(1).first
  end
end
