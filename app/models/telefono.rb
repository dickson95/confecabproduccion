=begin
Cuando alguna entidad desea tener muchos números de contacto

ATRIBUTOS
TELEFONO: Numero de teléfono

=end
class Telefono < ApplicationRecord
  belongs_to :contacto
  has_many :extensiones, dependent: :delete_all

  validates :telefono, presence: true
  accepts_nested_attributes_for :extensiones, allow_destroy: true
end
