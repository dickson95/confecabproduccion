class EmailClienteToClientes < ActiveRecord::Migration[5.0]
  def change
    add_column :clientes, :asunto, :string
    add_column :clientes, :mensaje, :string
  end
end
