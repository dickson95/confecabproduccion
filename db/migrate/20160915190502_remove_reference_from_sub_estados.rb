class RemoveReferenceFromSubEstados < ActiveRecord::Migration[5.0]
  def change
    remove_reference :sub_estados, :estado, foreign_key: true
  end
end
