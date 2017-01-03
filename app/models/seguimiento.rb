class Seguimiento < ApplicationRecord
  belongs_to :control_lote

  validates :cantidad, presence: true
  validate :cant_vs_cant, if: "!cantidad.nil?"

  def cant_vs_cant
    sum_process = confirm_cantidades(control_lote_id, cantidad)
    if sum_process != @lote.cantidad
      errors.add(:cantidad, "La cantidad en proceso con la original del lote no coincide")
    else
      @prev.update(:cantidad => @cant_aux)
    end
  end

  private

  # Recupera el lote previo y suma la cantidad de los procesos actuales
  def confirm_cantidades(control_lote_id, cantidad)
    current = ControlLote.find(control_lote_id)
    set_lote(current.lote_id)
    @prev = ControlLote.prev(current.id, @lote.id)
    @cant_aux = @prev.cantidad - cantidad
    ControlLote.where("lote_id = ? AND estado_id > 2", @lote.id ).sum(:cantidad)
  end

  def set_lote(id)
    @lote = Lote.select(:id, :cantidad).where(:id => id).first
  end
end
