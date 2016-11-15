class Estado < ApplicationRecord
    has_many :control_lotes
    
    #Validaciones
    validates :estado, presence: true
    
    # Métodos
    def name
        self.estado.upcase
    end
end
