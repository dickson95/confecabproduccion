class Correo < ApplicationRecord
  belongs_to :contacto
  validates :correo, presence: true
end
