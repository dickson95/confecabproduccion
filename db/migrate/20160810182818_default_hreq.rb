class DefaultHreq < ActiveRecord::Migration[5.0]
  def change
    change_column_default :lotes, :h_req, 0
  end
end
