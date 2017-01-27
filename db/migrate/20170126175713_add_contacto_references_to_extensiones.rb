class AddContactoReferencesToExtensiones < ActiveRecord::Migration[5.0]
  def change
    add_reference :extensiones, :contacto, index: true
  end
end
