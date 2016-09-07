class CreateSubEstados < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_estados do |t|
      t.string :sub_estado, null: false
      t.references :estado, foreign_key: true

      t.timestamps
    end
  end
end
