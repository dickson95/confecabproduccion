class Responsables < ActiveRecord::Migration[5.0]
  def change
    add_column :control_lotes, :responsable, :string
    add_column :lotes, :respon_insumos, :string
    add_column :lotes, :respon_integracion, :string
    add_column :lotes, :respon_edicion, :string
  end
end
