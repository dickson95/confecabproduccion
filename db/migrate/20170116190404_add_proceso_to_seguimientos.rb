class AddProcesoToSeguimientos < ActiveRecord::Migration[5.0]
  def change
    add_column :seguimientos, :proceso, :boolean, default: true
  end
end
