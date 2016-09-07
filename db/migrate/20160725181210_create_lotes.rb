class CreateLotes < ActiveRecord::Migration[5.0]
  def change
    create_table :lotes do |t|
      t.decimal :precio_unitario, null: true
      t.string :empresa, null: true
      t.string :color_prenda, null: true
      t.string :no_remision, null: true
      t.string :no_factura, null: true
      t.date :fecha_entr_prog, null: false
      t.integer :cantidad, null: true
      t.string :prioridad, null: true
      t.string :op, null: false
      t.date :fecha_entrada, null: false
      t.date :fecha_salida, null: true
      t.date :fecha_revision, null: true
      t.date :fecha_entrega, null: true
      t.text :observaciones, null: true
      t.boolean :final, null: true
      t.references :referencia, foreign_key: true, null: true
      t.references :cliente, foreign_key: true, null: false
      t.references :tipo_prenda, foreign_key: true, null: true

      t.timestamps
    end
  end
end
