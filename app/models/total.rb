class Total < ApplicationRecord
    # Relaciones
    has_many :cantidades
    
    # Validaciones
    validates :total, presence: true
    
    # Métodos
    def name
        self.total
    end
end
