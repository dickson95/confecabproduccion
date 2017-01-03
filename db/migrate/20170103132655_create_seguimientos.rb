class CreateSeguimientos < ActiveRecord::Migration[5.0]
  def change
    create_table :seguimientos do |t|
      t.integer :cantidad
      t.references :control_lote, foreign_key: true

      t.timestamps
    end
  end
end
