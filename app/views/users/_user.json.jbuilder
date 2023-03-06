# frozen_string_literal: true

json.extract!(user, :id, :user_id, :name, :username, :password, :is_admin, :created_at, :updated_at)
json.url(user_url(user, format: :json))
