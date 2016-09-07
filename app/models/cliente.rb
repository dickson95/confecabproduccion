class Cliente < ApplicationRecord
    
    validates :cliente, :email, presence: true
    
    def name
        self.cliente
    end
end
