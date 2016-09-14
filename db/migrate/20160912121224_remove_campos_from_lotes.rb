class RemoveCamposFromLotes < ActiveRecord::Migration[5.0]
  def change
    remove_column :lotes, :color_prenda, :string
    remove_column :lotes, :descripcion, :string
    remove_column :lotes, :prioridad, :string
    remove_column :control_lotes, :min_p_total
  end
end
