# By: Alan

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

# New application request integration tests

# User Variables
# Application Developed | Contact Name | Contact Email | Officer Position | Github Link | Year Developed | Notes

# RSpec.describe 'New valid application requests', type: :feature do
#     #Making a request with valid application information
#     scenario 'Adding valid application | Should add new application to database and view section' do
#       visit new_organization_path
#       org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
#       contact = Contact.create(personID: 1, orgID: 1, year: '02-24-2023', name: 'Person A',
#                                email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')

#       visit applications_path
#       click_on 'New application'
#       fill_in 'application[applicationID]', with: '1'
#       fill_in 'application[orgID]', with: '1'
#       fill_in 'application[name]', with: 'Valid application'
#       fill_in 'application[datebuilt]', with: '02-24-2023'
#       fill_in 'application[githublink]', with: 'github.com'
#       fill_in 'application[description]', with: 'First application test'
#       click_on 'Create Application'
#       expect(page).to have_content('Valid application')
#     end
# end
  
# RSpec.describe 'Invalid application request', type: :feature do
# # Making a request with invalid application information
# scenario 'Invalid application | Should have a popup with information warning about each invalid field' do
#     visit new_organization_path
#     org = Organization.create(orgID: 2, name: 'Test org 2', description: 'description')
#     contact = Contact.create(personID: 1, orgID: 2, year: '02-24-2023', name: 'Person A',
#                             email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')

#     visit applications_path
#     click_on 'New application'
#     fill_in 'application[applicationID]', with: '2'
#     fill_in 'application[orgID]', with: '2'
#     fill_in 'application[name]', with: 'Invalid application'
#     fill_in 'application[datebuilt]', with: '02-24-2023'
#     # fill_in 'application[githublink]', with: ''
#     # fill_in 'application[description]', with: ''
#     click_on 'Create Application'
#     expect(page).to have_content('Invalid input:')
#     expect(page).to have_content('Github')
#     expect(page).to have_content('Description')
#     expect(page).to have_content('Ok')
# end
# end

# RSpec.describe 'Invalid applicationID', type: :feature do
# # Making a request with invalid applicationID
# scenario 'Invalid applicationID | Should have a popup with information warning' do
#     visit new_organization_path
#     org = Organization.create(orgID: 3, name: 'Test org 3', description: 'description')
#     contact = Contact.create(personID: 1, orgID: 1, year: '02-24-2023', name: 'Person A',
#                             email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')

#     visit applications_path
#     click_on 'New application'
#     fill_in 'application[applicationID]', with: '-1'
#     fill_in 'application[orgID]', with: '3'
#     fill_in 'application[name]', with: 'Invalid applicationID'
#     fill_in 'application[datebuilt]', with: '02-28-2023'
#     fill_in 'application[githublink]', with: 'github.com'
#     fill_in 'application[description]', with: 'Invalid applicationID desc'
#     click_on 'Create Application'
#     expect(page).to have_content('Invalid input:')
#     expect(page).to have_content('ApplicationID invalid!')
#     expect(page).to have_content('Ok')
# end
# end

# RSpec.describe 'Missing orgID', type: :feature do
#     # Making a request with an orgID that does not exist
#     scenario 'Non existing orgID | Should have a popup with information warning' do
#     visit applications_path
#     click_on 'New application'
#     fill_in 'application[applicationID]', with: '4'
#     fill_in 'application[orgID]', with: '10'
#     fill_in 'application[name]', with: 'Non existing orgID'
#     fill_in 'application[datebuilt]', with: '02-28-2023'
#     fill_in 'application[githublink]', with: 'github.com'
#     fill_in 'application[description]', with: 'Non existing orgID desc'
#     click_on 'Create Application'
#     expect(page).to have_content('Invalid input:')
#     expect(page).to have_content('OrgID does not exist!')
#     expect(page).to have_content('Ok')
# end
# end

# RSpec.describe 'Invalid orgID', type: :feature do
#     # Making a request with a orgID that is impossible to have
#     scenario 'Invalid orgID | Should have a popup with information warning' do
#     visit applications_path
#     click_on 'New application'
#     fill_in 'application[applicationID]', with: '5'
#     fill_in 'application[orgID]', with: '-1'
#     fill_in 'application[name]', with: 'Invalid orgID'
#     fill_in 'application[datebuilt]', with: '02-28-2023'
#     fill_in 'application[githublink]', with: 'github.com'
#     fill_in 'application[description]', with: 'Invalid orgID desc'
#     click_on 'Create Application'
#     expect(page).to have_content('Invalid input:')
#     expect(page).to have_content('OrgID does not exist!')
#     expect(page).to have_content('Ok')
#     end
# end