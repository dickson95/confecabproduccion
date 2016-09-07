class Decimal < ActiveRecord::Migration[5.0]
  def change
    change_column(:control_lotes, :min_u, :decimal, precision: 9, scale: 2)
    change_column(:control_lotes, :min_p_total, :decimal, precision: 9, scale: 2)
  end
end
