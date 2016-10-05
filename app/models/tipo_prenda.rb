class TipoPrenda < ApplicationRecord
    has_many :lotes
    
    validates :tipo, presence: true
    
    def name
        self.tipo
    end

    def self.hash_ids
    	tipos = select("id, tipo")
    	hash_ids = Hash.new
    	tipos.each do |t|
    		hash_ids[t.id] = t.tipo
    	end
    	return hash_ids
    end
end
