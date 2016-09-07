class AddTotalRefToColoresLotes < ActiveRecord::Migration[5.0]
  def change
    add_reference :colores_lotes, :total, foreign_key: true
  end
end
