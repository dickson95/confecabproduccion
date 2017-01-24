class AddPasaManualToEstados < ActiveRecord::Migration[5.0]
  def change
    add_column :estados, :pasa_manual, :boolean, default: false
  end
end
