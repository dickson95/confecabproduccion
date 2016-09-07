class CreateTallas < ActiveRecord::Migration[5.0]
  def change
    create_table :tallas do |t|
      t.string :talla, :null => false

      t.timestamps
    end
  end
end
