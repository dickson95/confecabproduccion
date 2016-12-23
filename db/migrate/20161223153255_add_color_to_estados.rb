class AddColorToEstados < ActiveRecord::Migration[5.0]
  def change
    add_column :estados, :color, :string
  end
end
