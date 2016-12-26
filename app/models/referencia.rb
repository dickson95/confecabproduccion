class Referencia < ApplicationRecord
    
    validates :referencia, presence: true
    
    def name
        self.referencia
    end
    
    def referencia=(val)
      self[:referencia] = val.upcase
    end

    def self.hash_ids
        result = select("id, referencia").as_json
        hash_ids = Hash.new
        result.each do |r|
            hash_ids[r["id"]] = r["referencia"]
        end
        return hash_ids
    end
end
