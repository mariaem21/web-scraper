# By: Maria

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

# Exclude organizations from list of potential customers integration tests

RSpec.describe 'Exclude organizations', type: :feature do
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

    scenario 'Exclude the first organization' do

        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
            :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path
        
        # first, visit the page with the table
        visit organizations_path

        # Get the first row of table
        first_row = page.find('table#non-exclude-items tbody tr:first-child')
        
        # Get the first organization name
        organization_name = page.find('table#non-exclude-items tbody tr:first-child td:nth-child(2)')
        @organization_name_text = organization_name.text
        # puts "Organization being excluded: #{organization_name_text}"

        # then, find the checkbox element in the first row of the table
        checkbox = find(:css, 'table#non-exclude-items tbody tr:first-child input[type="checkbox"]')

        # check the checkbox
        checkbox.check

        # assert that the checkbox is checked
        expect(checkbox).to be_checked

        expect(page).to have_content(@organization_name_text)

        click_button "Exclude Selected Org(s)", match: :first
        
        # puts "Organization being excluded: #{@organization_name_text}"
        expect(page).not_to have_content(@organization_name_text)
    end
end