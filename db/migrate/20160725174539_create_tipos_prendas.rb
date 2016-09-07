class CreateTiposPrendas < ActiveRecord::Migration[5.0]
  def change
    create_table :tipos_prendas do |t|
      t.string :tipo, null: false

      t.timestamps
    end
  end
end
