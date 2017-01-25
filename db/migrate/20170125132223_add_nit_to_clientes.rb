class AddNitToClientes < ActiveRecord::Migration[5.0]
  def change
    add_column :clientes, :nit, :string
  end
end
