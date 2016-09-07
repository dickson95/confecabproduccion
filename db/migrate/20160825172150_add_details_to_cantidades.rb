class AddDetailsToCantidades < ActiveRecord::Migration[5.0]
  def change
    change_column_default :cantidades, :cantidad, 0
  end
end
