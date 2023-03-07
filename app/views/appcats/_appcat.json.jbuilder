# frozen_string_literal: true

json.extract!(appcat, :id, :appcatID, :categoryID, :applicationID, :created_at, :updated_at)
json.url(appcat_url(appcat, format: :json))
