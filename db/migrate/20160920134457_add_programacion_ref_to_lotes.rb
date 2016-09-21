class AddProgramacionRefToLotes < ActiveRecord::Migration[5.0]
  def change
    add_reference :lotes, :programacion, foreign_key: true
    remove_column :lotes, :mes
	remove_column :lotes, :h_total
  end
end
