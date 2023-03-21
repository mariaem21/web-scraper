# frozen_string_literal: true
# location: spec/unit/unit_spec.rb
require 'rails_helper'

RSpec.describe Application, type: :model do
  it 'is not valid if application ID is not unique' do
    org1 = Organization.create(orgID: 1, name: 'Org 1', description: 'description')
    app1 = Application.create(applicationID: 1, orgID: 1, name: 'App 1', datebuilt: 20_210_621,
                              githublink: 'link1', description: 'description')
    app2 = Application.create(applicationID: 1, orgID: 1, name: 'App 2', datebuilt: 20_210_621,
                              githublink: 'link2', description: 'different')
  end
end