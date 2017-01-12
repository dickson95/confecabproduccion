class SubEstado < ApplicationRecord
  belongs_to :estado
  has_many :control_lotes
    validates :sub_estado, presence: true
    def name
        self.sub_estado
    end

    def sub_estado=(val)
    	self[:sub_estado] = val.upcase
    end
end
