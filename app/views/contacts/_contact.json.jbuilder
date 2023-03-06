# frozen_string_literal: true

json.extract!(contact, :id, :contact_id, :organization_id, :year, :name, :email, :officer_position, :description, :created_at, :updated_at)
json.url(contact_url(contact, format: :json))
