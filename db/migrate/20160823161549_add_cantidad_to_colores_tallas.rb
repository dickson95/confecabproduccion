class AddCantidadToColoresTallas < ActiveRecord::Migration[5.0]
  def change
    add_column :colores_tallas, :cantidad, :integer
  end
end
