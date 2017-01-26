class Correo < ApplicationRecord
  $util = Util.new
  belongs_to :contacto
  validates :correo, presence: true

  def _correo
    $util.hyphen_or_string(self.correo)
  end
end
