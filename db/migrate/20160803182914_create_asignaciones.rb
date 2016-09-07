class CreateAsignaciones < ActiveRecord::Migration[5.0]
  def change
    create_table :asignaciones do |t|
      t.references :user, foreign_key: true
      t.references :role, foreign_key: true

      t.timestamps
    end
  end
end
