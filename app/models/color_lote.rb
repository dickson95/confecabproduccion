class ColorLote < ApplicationRecord
  # Relaciones
  belongs_to :color
  belongs_to :lote
  belongs_to :total
  has_many :cantidades
  accepts_nested_attributes_for :cantidades, allow_destroy: true

  # Métodos
  def colores_lotes_for_form
    collection = cantidades.where(lote_id: id)
    collection.any? ? collection : cantidades.build
  end
end
