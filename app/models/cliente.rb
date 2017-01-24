class Cliente < ApplicationRecord
	has_many :lotes
	validates :cliente, presence: true
	validates :empresa, inclusion: { in: [ true, false ] }
	
	def name
		self.cliente
	end

	def cliente=(val)
		self[:cliente] = val.upcase
	end

	def self.hash_ids
		result = select("id, cliente").as_json
		hash_ids = Hash.new
		result.each do |r|
			hash_ids[r["id"]] = r["cliente"]
		end
		return hash_ids
	end
end
