class Nulo < ActiveRecord::Migration[5.0]
  def change
    remove_column(:lotes, :fecha_entr_prog)
  end
end
