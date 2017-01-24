class AddFechaSalidaToSeguimientos < ActiveRecord::Migration[5.0]
  def change
    add_column :seguimientos, :fecha_salida, :date
  end
end
