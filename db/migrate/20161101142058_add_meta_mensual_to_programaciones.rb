class AddMetaMensualToProgramaciones < ActiveRecord::Migration[5.0]
  def change
    add_column :programaciones, :meta_mensual, :integer
  end
end
