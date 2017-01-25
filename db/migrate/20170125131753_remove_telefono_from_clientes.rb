class RemoveTelefonoFromClientes < ActiveRecord::Migration[5.0]
  def change
    remove_column :clientes, :telefono, :string
  end
end
