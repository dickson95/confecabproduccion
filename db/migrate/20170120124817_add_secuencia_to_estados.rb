class AddSecuenciaToEstados < ActiveRecord::Migration[5.0]
  def change
    add_column :estados, :secuencia, :integer, unique: true
  end
end
