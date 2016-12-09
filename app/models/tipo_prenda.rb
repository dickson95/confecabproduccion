class TipoPrenda < ApplicationRecord
    has_many :lotes
    
    validates :tipo, presence: true
    
    def name
        self.tipo
    end
    def tipo=(val)
        self[:tipo] = val.upcase
    end
    def self.hash_ids
    	result = select("id, tipo").as_json
    	hash_ids = Hash.new
    	result.each do |r|
    		hash_ids[r["id"]] = r["tipo"]
    	end
    	return hash_ids
    end
end
