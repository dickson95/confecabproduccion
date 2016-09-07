class CamposNuevosLotes < ActiveRecord::Migration[5.0]
  def change
    rename_column :lotes, :cantidad, :can_insumos
    rename_column :lotes, :final, :fin_insumos
    rename_column :lotes, :observaciones, :obs_insumos
    add_column :lotes, :obs_integracion, :text
    add_column :lotes, :fin_integracion, :boolean
    add_column :lotes, :can_integracion, :integer
  end
end

