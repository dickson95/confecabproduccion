class CreateControlLotes < ActiveRecord::Migration[5.0]
  def change
    create_table :control_lotes do |t|
      t.datetime :fecha_ingreso, null: false
      t.datetime :fecha_salida, null: true
      t.string :responsable_ingreso, null: false, :default => 'Esteban'
      t.string :responsable_salida, null: true
      t.references :lote, foreign_key: true, optional: false
      t.references :estado, foreign_key: true, null: false
      t.references :sub_estado, foreign_key: true, optional: true

      t.timestamps
    end
  end
end
