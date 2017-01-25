class RemoveExtensionFromContactos < ActiveRecord::Migration[5.0]
  def change
    remove_column :contactos, :extension, :string
  end
end
