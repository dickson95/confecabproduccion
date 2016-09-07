class ChangeMensajeToClientes < ActiveRecord::Migration[5.0]
  def change
    change_column :clientes, :mensaje, :text
  end
end
