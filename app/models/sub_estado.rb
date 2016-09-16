class SubEstado < ApplicationRecord
  belongs_to :estado
    validates :sub_estado, presence: true
    def name
        self.sub_estado
    end
end
