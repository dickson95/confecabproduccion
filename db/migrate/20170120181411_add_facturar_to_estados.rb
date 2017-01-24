class AddFacturarToEstados < ActiveRecord::Migration[5.0]
  def change
    add_column :estados, :facturar, :boolean, default: false
  end
end
