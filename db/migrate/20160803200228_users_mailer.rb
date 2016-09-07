class UsersMailer < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :database_authenticatable, :string
    add_column :users, :confirmable, :string
  end
end
