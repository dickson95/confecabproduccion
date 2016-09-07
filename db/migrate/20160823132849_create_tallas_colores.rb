class CreateTallasColores < ActiveRecord::Migration[5.0]
  def change
    create_table :tallas_colores do |t|
      t.belongs_to :talla, index: true
      t.belongs_to :color, index: true
      t.belongs_to :lote, index: true

      t.timestamps
    end
  end
end
