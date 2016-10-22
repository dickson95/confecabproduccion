class Cliente < ApplicationRecord
	
	validates :cliente, presence: true
	validates :empresa, inclusion: { in: [ true, false ] }
	
	def name
		self.cliente
	end
	
	def self.to_boolean(str)
		str == "true"
	end
end
