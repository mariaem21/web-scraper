# By: Alan

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

# New application request integration tests

# User Variables
# Application Developed | Contact Name | Contact Email | Officer Position | Github Link | Year Developed | Notes

RSpec.describe 'New valid application requests', type: :feature do
  scenario 'Adding valid application | Should add new application to database and view section' do
    visit new_organization_path
    org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
    contact = Contact.create(personID: 1, orgID: 1, year: '02-24-2023', name: 'Person A',
                             email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')

    visit applications_path
    click_on 'New application'
    fill_in 'application[application_id]', with: '1'
    fill_in 'application[organization_id]', with: '1'
    fill_in 'application[name]', with: 'Valid application'
    fill_in 'application[date_built]', with: 20_210_621
    fill_in 'application[github_link]', with: 'github.com'
    fill_in 'application[description]', with: 'First application test'
    click_on 'Create Application'
    expect(page).to have_content('Valid application')
  end
end

RSpec.describe 'Invalid application information request', type: :feature do
  scenario 'Invalid github link and description | Should have a popup with information warning about each invalid field' do
    visit new_organization_path
    org = Organization.create(orgID: 2, name: 'Test org 2', description: 'description')
    contact = Contact.create(personID: 1, orgID: 2, year: '02-24-2023', name: 'Person A',
                             email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')

    visit applications_path
    click_on 'New application'
    fill_in 'application[applicationID]', with: '2'
    fill_in 'application[orgID]', with: '2'
    fill_in 'application[name]', with: 'Invalid application'
    fill_in 'application[datebuilt]', with: 20_210_621
    # fill_in 'application[githublink]', with: ''
    # fill_in 'application[description]', with: ''
    click_on 'Create Application'
    expect(page).to have_content('errors prohibited this application from being saved:')
    expect(page).to have_content('Githublink can\'t be blank')
    expect(page).to have_content('Description can\'t be blank')
  end

  scenario 'Invalid name and date built', type: :feature do
    visit applications_path
    click_on 'New application'
    fill_in 'application[applicationID]', with: '2'
    fill_in 'application[orgID]', with: '2'
    fill_in 'application[name]', with: ''
    fill_in 'application[datebuilt]', with: ''
    fill_in 'application[githublink]', with: 'github.com'
    fill_in 'application[description]', with: 'invalid test app'
    click_on 'Create Application'
    expect(page).to have_content('errors prohibited this application from being saved:')
    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_content('Datebuilt can\'t be blank')
  end
end

RSpec.describe 'Negative applicationID', type: :feature do
  scenario 'Negative applicationID | Should have a popup with information warning' do
    visit new_organization_path
    org = Organization.create(orgID: 3, name: 'Test org 3', description: 'description')
    contact = Contact.create(personID: 1, orgID: 3, year: '02-24-2023', name: 'Person A',
                             email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')

    visit applications_path
    click_on 'New application'
    fill_in 'application[applicationID]', with: '-1'
    fill_in 'application[orgID]', with: '3'
    fill_in 'application[name]', with: 'Invalid applicationID'
    fill_in 'application[datebuilt]', with: 20_210_621
    fill_in 'application[githublink]', with: 'github.com'
    fill_in 'application[description]', with: 'Invalid applicationID desc'
    click_on 'Create Application'
    expect(page).to have_content('error prohibited this application from being saved:')
    expect(page).to have_content('Applicationid must be greater than 0')
  end
end

RSpec.describe 'Non existing orgID', type: :feature do
  scenario 'Non existing orgID | Should have a popup with information warning' do
    visit applications_path
    click_on 'New application'
    fill_in 'application[applicationID]', with: '4'
    fill_in 'application[orgID]', with: '10'
    fill_in 'application[name]', with: 'Non existing orgID'
    fill_in 'application[datebuilt]', with: 20_210_621
    fill_in 'application[githublink]', with: 'github.com'
    fill_in 'application[description]', with: 'Non existing orgID desc'
    click_on 'Create Application'
    expect(page).to have_content('error prohibited this application from being saved:')
    expect(page).to have_content('Orgid must have a valid organization ID')
  end
end

RSpec.describe 'Negative orgID', type: :feature do
  scenario 'Negative orgID | Should have a popup with information warning' do
    visit applications_path
    click_on 'New application'
    fill_in 'application[applicationID]', with: '5'
    fill_in 'application[orgID]', with: '-1'
    fill_in 'application[name]', with: 'Invalid orgID'
    fill_in 'application[datebuilt]', with: 20_210_621
    fill_in 'application[githublink]', with: 'github.com'
    fill_in 'application[description]', with: 'Invalid orgID desc'
    click_on 'Create Application'
    expect(page).to have_content('errors prohibited this application from being saved:')
    expect(page).to have_content('Orgid must be greater than 0')
    expect(page).to have_content('Orgid must have a valid organization ID')
  end
end
