# frozen_string_literal: true

json.extract!(contact, :id, :personID, :orgID, :year, :name, :email, :officerposition, :description, :created_at, :updated_at)
json.url(contact_url(contact, format: :json))
