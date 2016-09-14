class AddDefaultToControlLote < ActiveRecord::Migration[5.0]
  def change
    change_column_default :control_lotes, :sub_estado_id, 0
  end
end
