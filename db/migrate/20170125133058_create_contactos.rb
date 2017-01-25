class CreateContactos < ActiveRecord::Migration[5.0]
  def change
    create_table :contactos do |t|
      t.string :contacto
      t.string :cargo
      t.string :extension
      t.references :cliente, foreign_key: true

      t.timestamps
    end
  end
end
