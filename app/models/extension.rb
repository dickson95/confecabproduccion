class Extension < ApplicationRecord
  $util = Util.new
  belongs_to :telefono
  has_one :contacto, dependent: :destroy
  accepts_nested_attributes_for :contacto, allow_destroy: true

  validates :extension, presence: true

  def _extension
    $util.hyphen_or_string(self.extension)
  end
end
