class RemoveClienteReferencesFromTelefonos < ActiveRecord::Migration[5.0]
  def change
    remove_reference :telefonos, :cliente, foreign_key: true
  end
end
