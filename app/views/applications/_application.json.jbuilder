json.extract! application, :id, :applicationID, :orgID, :name, :datebuilt, :githublink, :description, :created_at, :updated_at
json.url application_url(application, format: :json)
