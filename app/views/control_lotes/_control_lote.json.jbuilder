json.extract! control_lote, :id, :sub_estado, :lote_id, :fecha_ingreso, :fecha_salida, :responsable_ingreso, :responsable_salida,:estado_id, :created_at, :updated_at
json.url control_lote_url(control_lote, format: :json)