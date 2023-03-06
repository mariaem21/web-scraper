# frozen_string_literal: true

json.extract!(organization, :id, :organization_id, :name, :description, :created_at, :updated_at)
json.url(organization_url(organization, format: :json))
