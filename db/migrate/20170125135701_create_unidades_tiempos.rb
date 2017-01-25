class CreateUnidadesTiempos < ActiveRecord::Migration[5.0]
  def change
    create_table :unidades_tiempos do |t|
      t.string :unidad
      t.integer :segundos

      t.timestamps
    end
  end
end
