class RemoveCantidadIdFromCantidades < ActiveRecord::Migration[5.0]
  def change
    remove_reference :cantidades, :cantidad
    add_column :cantidades, :cantidad, :integer
  end
end
