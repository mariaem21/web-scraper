# Table: contacts
# Assigned to: Maria

# frozen_string_literal: true
# location: spec/unit/unit_spec.rb
require 'rails_helper'

RSpec.describe Contact, type: :model do
    it 'is not valid if contact PK is not unique' do
      org1 = Organization.create(organization_id: 1, name: 'Student org A', description: 'Unique description')
      person1 = Contact.create(contact_id: 1, year: 20_210_621, name: 'Person A',
                               email: 'john@tamu.edu', officer_position: 'President', description: 'Unique description')
      person2 = Contact.create(contact_id: 1, year: 20_210_621, name: 'Person B',
                               email: 'johnsmith@tamu.edu', officer_position: 'Unknown', description: 'Different here')
      expect(person1).to be_valid
      expect(person2).to_not be_valid
    end

    # it 'is not valid if organization_id is not valid' do
    #   person1 = Contact.create(contact_id: 1, year: 20_210_621, name: 'Person B',
    #                            email: 'johnsmith@tamu.edu', officer_position: 'Unknown', description: 'Different here')
    #   expect(person1).to_not be_valid
    # end

    it 'is not valid if any field besides is blank' do
      org1 = Organization.create(organization_id: 1, name: 'Testing contact table', description: 'Unique description')
      person1 = Contact.create(contact_id: '', year: 20_210_621, name: 'Person A',
                               email: 'johnsmith@tamu.edu', officer_position: 'Unknown', description: 'Different here')
      # person2 = Contact.create(contact_id: 1, organization_id: '', year: 20_210_621, name: 'Person B',
      #                          email: 'johnsmith@tamu.edu', officer_position: 'Unknown', description: 'Different here')
      person3 = Contact.create(contact_id: 2, year: '', name: 'Person C',
                               email: 'johnsmith@tamu.edu', officer_position: 'Unknown', description: 'Different here')
      person4 = Contact.create(contact_id: 3, year: 20_210_621, name: '',
                               email: 'johnsmith@tamu.edu', officer_position: 'Unknown', description: 'Different here')
      person5 = Contact.create(contact_id: 4, year: 20_210_621, name: 'Person D',
                               email: '', officer_position: 'Unknown', description: 'Different here')
      person6 = Contact.create(contact_id: 5, year: 20_210_621, name: 'Person E',
                               email: 'johnsmith@tamu.edu', officer_position: '', description: 'Different here')
      person7 = Contact.create(contact_id: 6, year: 20_210_621, name: 'Person F',
                               email: 'johnsmith@tamu.edu', officer_position: 'Unknown', description: '')
      person8 = Contact.create(contact_id: 7, year: 20_210_621, name: 'Person G',
                               email: 'johnsmith@tamu.edu', officer_position: 'Unknown', description: 'Valid contact')
      expect(person1).to_not be_valid
      # expect(person2).to_not be_valid
      expect(person3).to_not be_valid
      expect(person4).to_not be_valid
      expect(person5).to_not be_valid
      expect(person6).to_not be_valid
      expect(person7).to_not be_valid
      expect(person8).to be_valid
    end
end
