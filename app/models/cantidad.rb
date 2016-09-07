class Cantidad < ApplicationRecord
    # Relaciones
    belongs_to :categoria
    belongs_to :color_lote
    belongs_to :total
    
    # Métodos
    def name
        self.cantidad
    end
end
