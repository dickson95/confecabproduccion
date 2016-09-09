class SubEstado < ApplicationRecord
  belongs_to :estado
    
    def name
        self.sub_estado
    end
end
