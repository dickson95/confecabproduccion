class RenameTallaIdFromColoresTallas < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :categorias_colores, :categoria, index: true
  end
end
