class RemoveMinUFromControlLotes < ActiveRecord::Migration[5.0]
  def change
    remove_column :control_lotes, :min_u, :string
  end
end
