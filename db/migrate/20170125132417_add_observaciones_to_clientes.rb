class AddObservacionesToClientes < ActiveRecord::Migration[5.0]
  def change
    add_column :clientes, :observaciones, :text
  end
end
