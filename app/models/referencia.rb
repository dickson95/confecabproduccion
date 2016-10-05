class Referencia < ApplicationRecord
    
    validates :referencia, presence: true
    
    def name
        self.referencia
    end
    
    def referencia=(val)
      self[:referencia] = val.upcase
    end
end
