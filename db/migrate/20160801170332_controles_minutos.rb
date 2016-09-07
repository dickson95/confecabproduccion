class ControlesMinutos < ActiveRecord::Migration[5.0]
  def change
    remove_column(:lotes, :precio_unitario)
    add_column(:control_lotes, :min_u, :decimal, precision: 5, scale: 2)
    add_column(:control_lotes, :min_p_total, :decimal, precision: 7, scale: 2)
  end
end
