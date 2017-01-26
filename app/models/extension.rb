class Extension < ApplicationRecord
  belongs_to :telefono
  validates :extension, presence: true
end
