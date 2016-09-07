class AddCantidadToLotes < ActiveRecord::Migration[5.0]
  def change
    add_column :lotes, :cantidad, :integer
  end
end
