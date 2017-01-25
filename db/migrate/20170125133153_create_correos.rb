class CreateCorreos < ActiveRecord::Migration[5.0]
  def change
    create_table :correos do |t|
      t.string :correo
      t.references :contacto, foreign_key: true

      t.timestamps
    end
  end
end
