class ChangeDefaultValueResponIngersoFromControlLotes < ActiveRecord::Migration[5.0]
  def change
  	change_column_default :control_lotes, :resp_ingreso_id, 1
  end
end
