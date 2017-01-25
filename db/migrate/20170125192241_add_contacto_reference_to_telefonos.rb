class AddContactoReferenceToTelefonos < ActiveRecord::Migration[5.0]
  def change
    add_reference :telefonos, :contacto, foreign_key: true
  end
end
