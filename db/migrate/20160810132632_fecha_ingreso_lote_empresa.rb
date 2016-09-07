class FechaIngresoLoteEmpresa < ActiveRecord::Migration[5.0]
  def change
    remove_column :lotes, :fecha_entrada
    remove_column :lotes, :fecha_salida
  end
end
