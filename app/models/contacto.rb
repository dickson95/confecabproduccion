=begin
Información de los contactos de los clientes

ATRIBUTOS

CONTACTO: Nombre del contacto
CARGO: Puesto de trabajo de la persona en la empresa cliente

=end
class Contacto < ApplicationRecord
  belongs_to :cliente
  has_many :correos, dependent: :delete_all
  has_many :telefonos, dependent: :delete_all

  validates :contacto, :cargo, presence: true

  accepts_nested_attributes_for :telefonos, allow_destroy: true
  accepts_nested_attributes_for :correos, allow_destroy: true

end
