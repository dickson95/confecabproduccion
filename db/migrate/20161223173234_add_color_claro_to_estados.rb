class AddColorClaroToEstados < ActiveRecord::Migration[5.0]
  def change
    add_column :estados, :color_claro, :string
  end
end
