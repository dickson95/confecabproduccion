class RenameCategoriasColoresToColoresLotes < ActiveRecord::Migration[5.0]
  def change
    rename_table :categorias_colores, :colores_lotes
    remove_reference :colores_lotes, :categoria
    remove_column :colores_lotes, :cantidad
  end
end
