=begin
Información de los contactos de los clientes

ATRIBUTOS

CONTACTO: Nombre del contacto
CARGO: Puesto de trabajo de la persona en la empresa cliente

=end
class Contacto < ApplicationRecord
  $util = Util.new
  belongs_to :cliente
  belongs_to :extension, optional: true, dependent: :destroy
  has_many :correos, dependent: :delete_all

  validates :contacto, :cargo, presence: true

  accepts_nested_attributes_for :correos, allow_destroy: true

  def _contacto
    $util.hyphen_or_string(self.contacto)
  end

  def _cargo
    $util.hyphen_or_string(self.cargo)
  end

end
