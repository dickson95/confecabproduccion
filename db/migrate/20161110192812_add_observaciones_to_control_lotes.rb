class AddObservacionesToControlLotes < ActiveRecord::Migration[5.0]
  def change
    add_column :control_lotes, :observaciones, :text
  end
end
