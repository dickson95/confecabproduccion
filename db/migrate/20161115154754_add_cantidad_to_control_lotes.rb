class AddCantidadToControlLotes < ActiveRecord::Migration[5.0]
  def change
    add_column :control_lotes, :cantidad, :integer
  end
end
