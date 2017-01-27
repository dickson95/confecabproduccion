class AddExtensionReferencesToContactos < ActiveRecord::Migration[5.0]
  def change
    add_reference :contactos, :extension, index: true
  end
end
