# frozen_string_literal: true
# location: spec/unit/unit_spec.rb
require 'rails_helper'

RSpec.describe Application, type: :model do
  it 'is not valid if application ID is not unique' do
    org1 = Organization.create(organization_id: 1, name: 'Org 1', description: 'description')
    app1 = Application.create(application_id: 1, organization_id: 1, name: 'App 1', date_built: 20_210_621,
                              github_link: 'link1', description: 'description')
    app2 = Application.create(application_id: 1, organization_id: 1, name: 'App 2', date_built: 20_210_621,
                              github_link: 'link2', description: 'different')
  end
end