class Cliente < ApplicationRecord
  require 'util'
  $util = Util.new
  has_many :lotes
  has_many :telefonos, dependent: :destroy
  has_many :contactos, dependent: :destroy

  validates :cliente, presence: true
  validates :empresa, inclusion: {in: [true, false]}

  accepts_nested_attributes_for :contactos, allow_destroy: true
  accepts_nested_attributes_for :telefonos, allow_destroy: true

  def name
    self.cliente
  end

  def _nit
    $util.hyphen_or_string(self.nit)
  end

  def _direccion
    $util.hyphen_or_string(self.direccion)
  end

  def _tiempo_pago
    $util.hyphen_or_string(self.tiempo_pago)
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
