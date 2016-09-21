class CreateProgramaciones < ActiveRecord::Migration[5.0]
  def change
    create_table :programaciones do |t|
      t.date :mes
      t.integer :horas
      t.string :costo

      t.timestamps
    end
  end
end
