class AddNombreAccionToEstados < ActiveRecord::Migration[5.0]
  def change
    add_column :estados, :nombre_accion, :string
  end
end
