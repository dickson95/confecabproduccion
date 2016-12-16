class AddIngresaraAPlantaToLotes < ActiveRecord::Migration[5.0]
  def change
    add_column :lotes, :ingresara_a_planta, :date
  end
end
