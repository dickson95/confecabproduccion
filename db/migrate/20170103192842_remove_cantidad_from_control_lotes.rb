class RemoveCantidadFromControlLotes < ActiveRecord::Migration[5.0]
  def change
    remove_column :control_lotes, :cantidad, :string
  end
end
