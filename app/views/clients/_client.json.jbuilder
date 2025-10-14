json.extract! client, :id, :office_id, :team_id, :medical_care, :name, :email, :address, :disease, :public_token, :note, :created_at, :updated_at
json.url client_url(client, format: :json)
