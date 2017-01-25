=begin
Cuando alguna entidad desea tener muchos números de contacto

ATRIBUTOS
TELEFONO: Numero de teléfono

=end
class Telefono < ApplicationRecord
  belongs_to :contacto
  has_many :extensiones

  validates :telefono, presence: true
end
