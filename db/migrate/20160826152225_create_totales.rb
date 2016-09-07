class CreateTotales < ActiveRecord::Migration[5.0]
  def change
    create_table :totales do |t|
      t.string :total
    end
    
    add_belongs_to :cantidades, :total, index: true
    
  end
end
