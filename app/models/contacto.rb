=begin
Información de los contactos de los clientes

ATRIBUTOS

CONTACTO: Nombre del contacto
CARGO: Puesto de trabajo de la persona en la empresa cliente

=end
class Contacto < ApplicationRecord
  belongs_to :cliente
  has_many :correos
  has_many :telefonos

  validates :contacto, :cargo, presence: true

end
