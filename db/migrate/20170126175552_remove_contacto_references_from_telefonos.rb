class RemoveContactoReferencesFromTelefonos < ActiveRecord::Migration[5.0]
  def change
    remove_reference :telefonos, :contacto, foreign_key: true
  end
end
