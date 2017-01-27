class RemoveContactoReferencesFromExtensiones < ActiveRecord::Migration[5.0]
  def change
    remove_reference :extensiones, :contacto, index: true
  end
end
