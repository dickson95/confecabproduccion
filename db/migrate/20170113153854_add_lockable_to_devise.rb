class AddLockableToDevise < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :locked_at, :datetime
    add_index :users, :unlock_token, unique: true
  end
end
