class SubEstado < ApplicationRecord
  belongs_to :estado
    validates :sub_estado, presence: true
    def name
        self.sub_estado
    end

    def sub_estado=(val)
    	self[:sub_estado] = val.upcase
    end
end
