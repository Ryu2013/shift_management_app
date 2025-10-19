json.extract! user_need, :id, :office_id, :user_id, :week, :start_time, :end_time, :created_at, :updated_at
json.url user_need_url(user_need, format: :json)
