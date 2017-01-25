=begin
Definir unidades de tiempo como los días, horas o minutos

ATRIBUTOS

UNIDAD: String con el nombre de la unidad de tiempo
SEGUNDOS: Integer con la cantidad de segundos deseada para la unidad

=end
class UnidadTiempo < ApplicationRecord
  has_many :clientes

  validates :unidad, presence: true
  validates :segundos, presence: true, numericality: true
end
