class Cliente < ApplicationRecord
  has_many :lotes
  has_many :contactos, dependent: :delete_all

  validates :cliente, presence: true
  validates :empresa, inclusion: {in: [true, false]}

  accepts_nested_attributes_for :contactos, allow_destroy: true

  def name
    self.cliente
  end

  def _nit
    nit = self.nit
    nit ? nit : "-"
  end

  def _direccion
    dir = self.direccion
    dir.nil? ? "-" : dir
  end

  def _tiempo_pago
    tiempo_pago = self.tiempo_pago
    tiempo_pago.nil? ? "-" : tiempo_pago
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
