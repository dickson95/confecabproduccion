class AddDefaultToLotes < ActiveRecord::Migration[5.0]
  def change
    change_column_default :lotes, :meta, 0
  end
end
