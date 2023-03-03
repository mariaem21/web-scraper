# Table: organizations
# Assigned to: Tripper

# frozen_string_literal: true
# location: spec/unit/unit_spec.rb
require 'rails_helper'

RSpec.describe Organization, type: :model do
    it 'is not valid if organization PK is not unique' do
      org1 = Organization.create(orgID: 1, name: 'Student org A', description: 'Unique description')
      org2 = Organization.create(orgID: 1, name: 'Student org B', description: 'Different here')
      expect(org1).to be_valid
      expect(org2).to_not be_valid
    end

    it 'is not valid if organization name is not unique' do
      org1 = Organization.create(orgID: 2, name: 'Student org A', description: 'Unique description')
      org2 = Organization.create(orgID: 3, name: 'Student org A', description: 'Different here')
      expect(org1).to be_valid
      expect(org2).to_not be_valid
    end
end