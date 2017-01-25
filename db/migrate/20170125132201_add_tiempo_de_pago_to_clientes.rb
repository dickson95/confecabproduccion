class AddTiempoDePagoToClientes < ActiveRecord::Migration[5.0]
  def change
    add_column :clientes, :tiempo_pago, :integer, default: 15
  end
end
