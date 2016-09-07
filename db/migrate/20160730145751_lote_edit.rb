class LoteEdit < ActiveRecord::Migration[5.0]
  def change
    drop_table(:programaciones)
    add_column(:lotes, 'descripcion', :text)
  	add_column(:lotes, 'meta',        :integer)
  	add_column(:lotes, 'h_req',       :integer)
  	add_column(:lotes, 'h_total',     :integer)
  	add_column(:lotes, 'precio_u',    :integer)
  	add_column(:lotes, 'precio_t',    :integer)
  	add_column(:lotes, 'mes',         :string)
  	add_column(:lotes, 'secuencia',   :integer)
  
  end
end
