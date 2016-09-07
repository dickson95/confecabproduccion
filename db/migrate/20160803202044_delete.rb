class Delete < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :database_authenticatable
    remove_column :users, :confirmable
  end
end
