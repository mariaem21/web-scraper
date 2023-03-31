# frozen_string_literal: true

json.extract!(application, :id, :application_id, :contact_organization_id, :name, :date_built, :github_link, :description, :created_at, :updated_at)
json.url(application_url(application, format: :json))
