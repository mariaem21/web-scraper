# By: Sana

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

# RSpec.describe('Connecting contacts to orgs and applications', type: :feature) do

#   scenario 'Shows correct contact info for orgs' do
#     org = Organization.create(organization_id: 1, name: 'A Battery', description: 'description')
#     contact = Contact.create(contact_id: 1, year: 20_210_621, name: 'Chad Parker',
#                              email: 'cparker@corps.tamu.edu', officer_position: 'President', description: 'Unique description')
#     cont_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
    
#     expect(Contact.find_by(contact_id: ContactOrganization.find_by(organization_id: 1).contact_id).name).to eq('Chad Parker')
#     expect(Contact.find_by(contact_id: ContactOrganization.find_by(organization_id: 1).contact_id).email).to eq('cparker@corps.tamu.edu')
#   end

#   scenario 'Shows correct contact info for applications' do
#     org = Organization.create(organization_id: 1, name: 'A Battery', description: 'description')
#     contact = Contact.create(contact_id: 1, year: 20_210_621, name: 'Chad Parker',
#                              email: 'cparker@corps.tamu.edu', officer_position: 'President', description: 'Unique description')
#     cont_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
#     app = Application.create(application_id: 1, contact_organization_id: 1, name: 'first application', date_built:20_210_621, github_link: 'github.com', description: 'test')

#     cont_org_id = Application.find_by(application_id: 1).contact_organization_id
#     cont_id = ContactOrganization.find_by(contact_organization_id: cont_org_id).contact_id
#     expect(Contact.find_by(contact_id: cont_id).name).to eq('Chad Parker')
#     expect(Contact.find_by(contact_id: cont_id).email).to eq('cparker@corps.tamu.edu')
#   end

#   scenario 'Same contact info for multiple applications' do
#     org = Organization.create(organization_id: 1, name: 'A Battery', description: 'description')
#     contact = Contact.create(contact_id: 1, year: 20_210_621, name: 'Chad Parker',
#                              email: 'cparker@corps.tamu.edu', officer_position: 'President', description: 'Unique description')
#     cont_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
#     app = Application.create(application_id: 1, contact_organization_id: 1, name: 'first application', date_built:20_210_621, github_link: 'github.com', description: 'test')
#     app2 = Application.create(application_id: 2, contact_organization_id: 1, name: 'second application', date_built:20_210_621, github_link: 'github.com', description: 'test')

#     cont_org_id = Application.find_by(application_id: 1).contact_organization_id
#     cont_id = ContactOrganization.find_by(contact_organization_id: cont_org_id).contact_id
#     expect(Contact.find_by(contact_id: cont_id).name).to eq('Chad Parker')
#     expect(Contact.find_by(contact_id: cont_id).email).to eq('cparker@corps.tamu.edu')

#     cont_org_id2 = Application.find_by(application_id: 2).contact_organization_id
#     cont_id2 = ContactOrganization.find_by(contact_organization_id: cont_org_id2).contact_id
#     expect(Contact.find_by(contact_id: cont_id2).name).to eq('Chad Parker')
#     expect(Contact.find_by(contact_id: cont_id2).email).to eq('cparker@corps.tamu.edu')
#   end

#   scenario 'Different contact info for multiple applications' do
#     org = Organization.create(organization_id: 1, name: 'A Battery', description: 'description')
#     contact = Contact.create(contact_id: 1, year: 20_210_621, name: 'Chad Parker',
#                              email: 'cparker@corps.tamu.edu', officer_position: 'President', description: 'Unique description')
#     cont_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)

#     contact2 = Contact.create(contact_id: 2, year: 20_210_621, name: 'John Doe',
#                              email: 'johndoe@tamu.edu', officer_position: 'President', description: 'Unique description')
#     cont_org2 = ContactOrganization.create(contact_organization_id: 2, contact_id: 2, organization_id: 1)

#     app = Application.create(application_id: 1, contact_organization_id: 1, name: 'first application', date_built:20_210_621, github_link: 'github.com', description: 'test')
#     app2 = Application.create(application_id: 2, contact_organization_id: 2, name: 'second application', date_built:20_210_621, github_link: 'github.com', description: 'test')

#     cont_org_id = Application.find_by(application_id: 1).contact_organization_id
#     cont_id = ContactOrganization.find_by(contact_organization_id: cont_org_id).contact_id
#     expect(Contact.find_by(contact_id: cont_id).name).to eq('Chad Parker')
#     expect(Contact.find_by(contact_id: cont_id).email).to eq('cparker@corps.tamu.edu')

#     cont_org_id2 = Application.find_by(application_id: 2).contact_organization_id
#     cont_id2 = ContactOrganization.find_by(contact_organization_id: cont_org_id2).contact_id
#     expect(Contact.find_by(contact_id: cont_id2).name).to eq('John Doe')
#     expect(Contact.find_by(contact_id: cont_id2).email).to eq('johndoe@tamu.edu')
#   end

# end