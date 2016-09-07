class IndexResponsables < ActiveRecord::Migration[5.0]
  def change
    remove_column :control_lotes, :responsable
    remove_column :control_lotes, :responsable_ingreso
    remove_column :control_lotes, :responsable_salida
    remove_column :lotes, :respon_insumos
    remove_column :lotes, :respon_integracion
    remove_column :lotes, :respon_edicion
    remove_column :lotes, :can_insumos
    add_column :control_lotes, :resp_ingreso_id, :integer, null: false
    add_column :control_lotes, :resp_salida_id, :integer
    add_column :lotes, :respon_insumos_id, :integer
    add_column :lotes, :respon_edicion_id, :integer, null: false
    add_index :control_lotes, :resp_ingreso_id
    add_index :control_lotes, :resp_salida_id
    add_index :lotes, :respon_insumos_id
    add_index :lotes, :respon_edicion_id
  end
end
