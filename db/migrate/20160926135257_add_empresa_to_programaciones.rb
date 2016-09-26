class AddEmpresaToProgramaciones < ActiveRecord::Migration[5.0]
  def change
    add_column :programaciones, :empresa, :boolean
  end
end
