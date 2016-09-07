class ChangeNameTallasColores < ActiveRecord::Migration[5.0]
  def change
    rename_table :tallas_colores, :colores_tallas
  end
end
