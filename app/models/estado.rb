class Estado < ApplicationRecord
    has_many :control_lotes
    
    #Validaciones
    validates :estado, :nombre_accion, :color, :color_claro, presence: true
    
    # Métodos
    def name
        self.estado.upcase
    end
end
