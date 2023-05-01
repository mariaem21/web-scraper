# By: Alan

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

# New application request integration tests

# User Variables
# Application Developed | Contact Name | Contact Email | Officer Position | Github Link | Year Developed | Notes

RSpec.describe 'New valid application requests', type: :feature do
  before(:all) {
    Organization.delete_all
    ContactOrganization.delete_all
    Contact.delete_all

    # Create 1st organization
    Organization.create(organization_id: 1, name: "Test Organization", description: 'Unique description')
    ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
    Contact.create(contact_id: 1, year: 20_210_621, name: 'Test Name',
          email: 'test_email@tamu.edu', officer_position: 'Test Officer Position', description: 'I am creating a new application for this organization.')
    
  }

  scenario "Going to application link and adding new application" do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, {
        :info =>{
        :email => 'test@tamu.edu'
        }
    })
    visit admin_google_oauth2_omniauth_authorize_path

    visit organizations_path
    within('table#non-exclude-items tbody tr:first-child td:nth-child(7)') do
      click_link('0')
    end

    # org_id = 1 # Replace with the organization ID for your test case
    # app_name = 'Test Application'
    # contact_name = 'John Smith'
    # contact_email = 'john.smith@example.com'
    # officer_position = 'CTO'
    # github_link = 'https://github.com/test/test-app'
    # date_built = '2022-05-01'
    # notes = 'This is a test application'
    # category = 'Testing'

    # within('form.create-new-item') do
    # page.execute_script("$('input#app_name_field').removeAttr('disabled')")
    # page.execute_script("$('input#contact_name_field').removeAttr('disabled')")
    # page.execute_script("$('input#contact_email_field').removeAttr('disabled')")
    # page.execute_script("$('input#officer_position_field').removeAttr('disabled')")
    # page.execute_script("$('input#github_link_field').removeAttr('disabled')")
    # page.execute_script("$('input#date_built_field').removeAttr('disabled')")
    # page.execute_script("$('input#notes_field').removeAttr('disabled')")
    # page.execute_script("$('input#category_field').removeAttr('disabled')")

    expect(page).to have_content('Add Application')
    # puts page.html

    fill_in 'app_name_field', with: 'Test Application'
    fill_in 'contact_name_field', with: 'John Smith'
    fill_in 'contact_email_field', with: 'john.smith@example.com'
    fill_in 'officer_position_field', with: 'CTO'
    fill_in 'github_position_field', with: 'https://github.com/test/test-app'
    fill_in 'date_built_field', with: '2022-05-01'
    fill_in 'notes_field', with: 'Test'
    fill_in 'category_field', with: 'Test'

    click_button 'Add New App'

    visit organizations_path
    within('table#non-exclude-items tbody tr:first-child td:nth-child(7)') do
      click_link('1')
    end

    # puts page.html

    expect(page).to have_content('Test Application')
    expect(page).to have_content('John Smith')
    expect(page).to have_content('john.smith@example.com')
    expect(page).to have_content('CTO')
    expect(page).to have_content('https://github.com/test/test-app')
    expect(page).to have_content('Test')
    expect(page).to have_content('Test')

    expect(Application.where(name: 'Test Application')).to exist

    # visit add_table_entry_applications_path(organization_id: org_id)
  end

  # scenario 'Adding valid application | Should add new application to database and view section' do
  #   OmniAuth.config.test_mode = true
  #   OmniAuth.config.add_mock(:google_oauth2, {
  #       :info =>{
  #       :email => 'test@tamu.edu'
  #       }
  #   })
  #   visit admin_google_oauth2_omniauth_authorize_path

  #   visit new_organization_path
  #   org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
  #   contact = Contact.create(contact_id: 1, year: '02-24-2023', name: 'Person A',
  #                            email: 'john@tamu.edu', officer_position: 'President', description: 'Unique description')
  #   contact_organization = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
  #   visit applications_path
  #   click_on 'New application'
  #   fill_in 'application[application_id]', with: '1'
  #   fill_in 'application[contact_organization_id]', with: '1'
  #   fill_in 'application[name]', with: 'Valid application'
  #   fill_in 'application[date_built]', with: 20_210_621
  #   fill_in 'application[github_link]', with: 'github.com'
  #   fill_in 'application[description]', with: 'First application test'
  #   click_on 'Create Application'
  #   expect(page).to have_content('Valid application')
  # end
end

# RSpec.describe 'Invalid application information request', type: :feature do
#   scenario 'Invalid github link and description | Should have a popup with information warning about each invalid field' do
#     visit new_organization_path
#     org = Organization.create(organization_id: 2, name: 'Test org 2', description: 'description')
#     contact = Contact.create(contact_id: 1, year: '02-24-2023', name: 'Person A',
#                              email: 'john@tamu.edu', officer_position: 'President', description: 'Unique description')
#     contact_organization = ContactOrganization.create(contact_organization_id: 2, contact_id: 1, organization_id: 2)
#     visit applications_path
#     click_on 'New application'
#     fill_in 'application[application_id]', with: '2'
#     fill_in 'application[contact_organization_id]', with: '2'
#     fill_in 'application[name]', with: 'Invalid application'
#     fill_in 'application[date_built]', with: 20_210_621
#     # fill_in 'application[github_link]', with: ''
#     # fill_in 'application[description]', with: ''
#     click_on 'Create Application'
#     expect(page).to have_content('errors prohibited this application from being saved:')
#     expect(page).to have_content('Github link can\'t be blank')
#     expect(page).to have_content('Description can\'t be blank')
#   end

#   scenario 'Invalid name and date built', type: :feature do
#     visit applications_path
#     click_on 'New application'
#     fill_in 'application[application_id]', with: '2'
#     fill_in 'application[contact_organization_id]', with: '2'
#     fill_in 'application[name]', with: ''
#     fill_in 'application[date_built]', with: ''
#     fill_in 'application[github_link]', with: 'github.com'
#     fill_in 'application[description]', with: 'invalid test app'
#     click_on 'Create Application'
#     expect(page).to have_content('errors prohibited this application from being saved:')
#     expect(page).to have_content('Name can\'t be blank')
#     expect(page).to have_content('Date built can\'t be blank')
#   end
# end

# RSpec.describe 'Negative applicationID', type: :feature do
#   scenario 'Negative applicationID | Should have a popup with information warning' do
#     visit new_organization_path
#     org = Organization.create(organization_id: 3, name: 'Test org 3', description: 'description')
#     contact = Contact.create(contact_id: 1, year: '02-24-2023', name: 'Person A',
#                              email: 'john@tamu.edu', officer_position: 'President', description: 'Unique description')
#     contact_organization = ContactOrganization.create(contact_organization_id: 3, contact_id: 1, organization_id: 3)
#     visit applications_path
#     click_on 'New application'
#     fill_in 'application[application_id]', with: '-1'
#     fill_in 'application[contact_organization_id]', with: '3'
#     fill_in 'application[name]', with: 'Invalid applicationID'
#     fill_in 'application[date_built]', with: 20_210_621
#     fill_in 'application[github_link]', with: 'github.com'
#     fill_in 'application[description]', with: 'Invalid applicationID desc'
#     click_on 'Create Application'
#     # expect(page).to have_content('error prohibited this application from being saved:')
#     # expect(page).to have_content('Application must be greater than 0')
#   end
# end

# RSpec.describe 'Non existing contact organization ID', type: :feature do
#   scenario 'Non existing contact orgID | Should have a popup with information warning' do
#     visit applications_path
#     click_on 'New application'
#     fill_in 'application[application_id]', with: '4'
#     fill_in 'application[contact_organization_id]', with: '10'
#     fill_in 'application[name]', with: 'Non existing orgID'
#     fill_in 'application[date_built]', with: 20_210_621
#     fill_in 'application[github_link]', with: 'github.com'
#     fill_in 'application[description]', with: 'Non existing contact_orgID desc'
#     click_on 'Create Application'
#     # expect(page).to have_content('error prohibited this application from being saved:')
#     # expect(page).to have_content('ContactOrganization Must have a valid contact organization ID')
#   end
# end

# RSpec.describe 'Negative contact orgID', type: :feature do
#   scenario 'Negative contact orgID | Should have a popup with information warning' do
#     visit applications_path
#     click_on 'New application'
#     fill_in 'application[application_id]', with: '5'
#     fill_in 'application[contact_organization_id]', with: '-1'
#     fill_in 'application[name]', with: 'Invalid orgID'
#     fill_in 'application[date_built]', with: 20_210_621
#     fill_in 'application[github_link]', with: 'github.com'
#     fill_in 'application[description]', with: 'Invalid orgID desc'
#     click_on 'Create Application'
#     # expect(page).to have_content('errors prohibited this application from being saved:')
#     # expect(page).to have_content('Organization must be greater than 0')
#     # expect(page).to have_content('Organization Must have a valid organization ID')
#   end
# end
