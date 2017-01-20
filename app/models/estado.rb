=begin
Estos son los procesos principales por los que los lotes del sistema van a pasar
Son administrados por un root del sistema y son vitales para el funcionamiento del mismo.
=end
class Estado < ApplicationRecord
  has_many :control_lotes

  #Validaciones
  validates :secuencia, uniqueness: true
  validates :pasa_cantidad, :facturar, inclusion: {in: [true, false]}
  validates :estado, :nombre_accion, :color, :color_claro, :secuencia, presence: true
  validate :facturar_al, :max_percent_new, on: :create
  validate :facturar_al, :max_percent_update, on: :update

  def facturar_al=(val)
      self[:facturar_al] = facturar ? val : 0
  end

  # Validar  que la suma de los procesos en sus porcentajes no supera el 100
  # No se tiene el último en cuenta pues este es la suma de los porcentajes
  def max_percent_new
    id_last = Estado.select(:id).last_estado.id
    current_sum = Estado.where("id <> ?", id_last).sum(:facturar_al)
    sum = current_sum + facturar_al
    errors.add(:facturar_al, "La suma de los porcentajes es mayor a 100%") if sum > 100 and id != id_last
  end

  def max_percent_update
    id_last = Estado.select(:id).last_estado.id
    current_sum = Estado.where("id <> ? AND id <> ?", id_last, id).sum(:facturar_al)
    sum = current_sum + facturar_al
    errors.add(:facturar_al, "La suma de los porcentajes es mayor a 100%") if sum > 100 and id != id_last
  end

  # Get name para los formularios que usan desplegables
  def name
    self.estado.upcase
  end

  def pasa
    self.pasa_cantidad ? "Sí" : "No"
  end

  # Seguimiento anterior
  def prev
    Estado.active.where("secuencia < ?", self.secuencia).order("secuencia desc").limit(1).first
  end
  # Proceso siguiente
  def next
    Estado.active.where("secuencia > ?", self.secuencia).order("secuencia asc").limit(1).first
  end

  def factura_asi
    if self.facturar
      +self.facturar_al
    else
      "No factura"
    end
  end

  # Traer el último con base a la secuencia
  def self.last_estado
    Estado.active.order("secuencia desc").limit(1).first
  end

  def self.active
    where(active: true)
  end

  def self.inactive
    where(active: false)
  end

end
