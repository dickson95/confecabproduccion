class AddPasaCantidadToEstados < ActiveRecord::Migration[5.0]
  def change
    add_column :estados, :pasa_cantidad, :boolean, default: false
  end
end
