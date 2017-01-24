class AddActiveToEstados < ActiveRecord::Migration[5.0]
  def change
    add_column :estados, :active, :boolean, default: true
  end
end
