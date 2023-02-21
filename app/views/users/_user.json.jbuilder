# frozen_string_literal: true

json.extract! user, :id, :userID, :name, :username, :password, :isadmin, :created_at, :updated_at
json.url user_url(user, format: :json)
