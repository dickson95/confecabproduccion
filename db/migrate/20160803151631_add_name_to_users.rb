class AddNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :telefono, :string
    add_column :users, :email, :string
  end
end
