json.extract! cliente, :id, :cliente, :telefono, :direccion, :email, :created_at, :updated_at
json.url cliente_url(cliente, format: :json)