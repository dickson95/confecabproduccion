class AddClienteReferencesToTelefonos < ActiveRecord::Migration[5.0]
  def change
    add_reference :telefonos, :cliente, foreign_key: true
  end
end
