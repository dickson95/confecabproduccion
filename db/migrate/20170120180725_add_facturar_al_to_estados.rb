class AddFacturarAlToEstados < ActiveRecord::Migration[5.0]
  def change
    add_column :estados, :facturar_al, :float, deafult: 0.0
  end
end
