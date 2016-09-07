class TipoPrenda < ApplicationRecord
    has_many :lotes
    
    validates :tipo, presence: true
    
    def name
        self.tipo
    end
end
