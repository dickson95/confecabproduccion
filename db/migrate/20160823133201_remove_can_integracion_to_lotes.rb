class RemoveCanIntegracionToLotes < ActiveRecord::Migration[5.0]
  def change
    remove_column :lotes, :can_integracion
  end
end
