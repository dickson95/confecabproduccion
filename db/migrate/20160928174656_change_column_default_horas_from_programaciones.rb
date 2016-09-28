class ChangeColumnDefaultHorasFromProgramaciones < ActiveRecord::Migration[5.0]
  def change
  	change_column_default :programaciones, :horas, 0
  	change_column_default :lotes, :cantidad, 0
  end
end
