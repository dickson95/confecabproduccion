class CreateCantidades < ActiveRecord::Migration[5.0]
  def change
    create_table :cantidades do |t|
      t.belongs_to :color_lote, index: true
      t.belongs_to :categoria, index: true
      t.belongs_to :cantidad, index: true
    end
  end
end
