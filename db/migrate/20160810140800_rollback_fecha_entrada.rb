class RollbackFechaEntrada < ActiveRecord::Migration[5.0]
  def change
    add_column :lotes, :fecha_entrada, :date
  end
end
