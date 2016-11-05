class AddDefaultValueToCantidadFromControlLote < ActiveRecord::Migration[5.0]
  def change
  	change_column_default :control_lotes, :cantidad, 0
  end
end
