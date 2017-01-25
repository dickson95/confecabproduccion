class CreateExtensiones < ActiveRecord::Migration[5.0]
  def change
    create_table :extensiones do |t|
      t.string :extension
      t.references :telefono, foreign_key: true

      t.timestamps
    end
  end
end
