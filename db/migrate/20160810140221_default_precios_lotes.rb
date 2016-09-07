class DefaultPreciosLotes < ActiveRecord::Migration[5.0]
  def change
    change_column_default :lotes, :precio_u, 0
    change_column_default :lotes, :precio_t, 0
  end
end
