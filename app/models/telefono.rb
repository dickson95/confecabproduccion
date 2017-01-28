=begin
Cuando alguna entidad desea tener muchos números de contacto

ATRIBUTOS
TELEFONO: Numero de teléfono

=end
class Telefono < ApplicationRecord
  $util = Util.new
  belongs_to :cliente
  has_many :extensiones, dependent: :destroy

  validates :telefono, presence: true, numericality: true
  accepts_nested_attributes_for :extensiones, allow_destroy: true

  def _telefono
    $util.hyphen_or_string(self.telefono)
  end
end
