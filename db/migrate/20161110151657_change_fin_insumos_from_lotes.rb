class ChangeFinInsumosFromLotes < ActiveRecord::Migration[5.0]
  def change
  	change_column_default :lotes, :fin_insumos, true
  end
end
