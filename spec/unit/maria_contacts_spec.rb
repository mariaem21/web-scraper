# Table: contacts
# Assigned to: Maria

# frozen_string_literal: true
# location: spec/unit/unit_spec.rb
require 'rails_helper'

RSpec.describe Contact, type: :model do
    it 'is not valid if contact PK is not unique' do
      org1 = Organization.create(organization_id: 1, name: 'Student org A', description: 'Unique description')
      person1 = Contact.create(contact_id: 1, organization_id: 1, year: 20_210_621, name: 'Person A',
                               email: 'john@tamu.edu', officer_position: 'President', description: 'Unique description')
      person2 = Contact.create(contact_id: 1, organization_id: 1, year: 20_210_621, name: 'Person B',
                               email: 'johnsmith@tamu.edu', officer_position: 'Unknown', description: 'Different here')
      expect(person1).to be_valid
      expect(person2).to_not be_valid
    end

    it 'is not valid if organization_id is not valid' do
      person1 = Contact.create(contact_id: 1, organization_id: 1, year: 20_210_621, name: 'Person B',
                               email: 'johnsmith@tamu.edu', officer_position: 'Unknown', description: 'Different here')
      expect(person1).to_not be_valid
    end
end
