class Color < ApplicationRecord
    # Relaciones
    has_and_belongs_to_many :lotes
    
    # Validaciones
    validates :color, presence: true
    
    # Métodos
    def name
        self.color
    end
end
