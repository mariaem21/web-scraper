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
    Application.delete_all
    ApplicationCategory.delete_all
    Category.delete_all

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

    expect(page).to have_content('Test Application')
    expect(page).to have_content('John Smith')
    expect(page).to have_content('john.smith@example.com')
    expect(page).to have_content('CTO')
    expect(page).to have_content('https://github.com/test/test-app')
    expect(page).to have_content('2022-05-01')
    expect(page).to have_content('Test')
    expect(page).to have_content('Test')

    expect(Application.where(name: 'Test Application')).to exist

    # visit add_table_entry_applications_path(organization_id: org_id)
  end
end

RSpec.describe 'Invalid application information request', type: :feature do
  scenario 'Invalid github link and notes field | Should have a popup with information warning' do
    Application.delete_all

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

    expect(page).to have_content('Add Application')
    # puts page.html

    fill_in 'app_name_field', with: 'Test Application'
    fill_in 'contact_name_field', with: 'John Smith'
    fill_in 'contact_email_field', with: 'john.smith@example.com'
    fill_in 'officer_position_field', with: 'CTO'
    fill_in 'github_position_field', with: ''
    fill_in 'date_built_field', with: '2022-05-01'
    fill_in 'notes_field', with: ''
    fill_in 'category_field', with: 'Test'

    click_button 'Add New App'

    expect(page).to have_content('Not all params were inputted')
    expect(Application.where(name: 'Test Application')).not_to exist
  end

  scenario 'Invalid name and date built', type: :feature do
    Application.delete_all

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

    expect(page).to have_content('Add Application')
    # puts page.html

    fill_in 'app_name_field', with: ''
    fill_in 'contact_name_field', with: 'John Smith'
    fill_in 'contact_email_field', with: 'john.smith@example.com'
    fill_in 'officer_position_field', with: 'CTO'
    fill_in 'github_position_field', with: 'https://github.com/test/test-app'
    fill_in 'date_built_field', with: ''
    fill_in 'notes_field', with: 'Test'
    fill_in 'category_field', with: 'Test'

    click_button 'Add New App'

    expect(page).to have_content('Not all params were inputted')
    expect(Application.where(name: 'Test Application')).not_to exist
  end
end
