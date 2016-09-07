class CreateClientes < ActiveRecord::Migration[5.0]
  def change
    create_table :clientes do |t|
      t.string :cliente, null: false
      t.string :telefono, null: true
      t.string :direccion, null: true
      t.string :email, null: false

      t.timestamps
    end
  end
end
