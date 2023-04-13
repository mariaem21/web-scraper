# By: Alan

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

# Exclude organizations from list of potential customers integration tests

RSpec.describe 'Exclude organizations', type: :feature do
    before(:all) {Organization.delete_all}
    before(:all) {ContactOrganization.delete_all}
    before(:all) {Contact.delete_all}

    before(:all) {Organization.create(organization_id: 1, name: 'Test Organization', description: 'Test org description')}
    before(:all) {ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)}
    before(:all) {Contact.create(contact_id: 1, year: 20_210_621, name: 'Alan Enriquez',
        email: 'age2001@tamu.edu', officer_position: 'President', description: 'My contact')}
        
    scenario 'Add application and exclude' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
            :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path

        visit organizations_path

        expect(page).to have_content('Test Organization')
        expect(page).to have_content('Alan Enriquez')
        expect(page).to have_content('age2001@tamu.edu')
        expect(page).to have_content('President')

        # puts find('tr', text: 'Test Organization')

        # find('tr', text: 'Test Organization').should have_content('Test Organization')
        # find('tr', text: 'Test Organization').should have_content('Alan Enriquez')
        # find('tr', text: 'Test Organization').should have_content('age2001@tamu.edu')
        # find('tr', text: 'Test Organization').should have_content('President')
        
        expect(page).to have_content('1')
        page.check('1')

        page.click_on('Save exclude orgs?')

        expect(page).to_not have_content('Test Organization')
        expect(page).to_not have_content('Alan Enriquez')
        expect(page).to_not have_content('age2001@tamu.edu')
        expect(page).to_not have_content('President')
    end
end

RSpec.describe 'Exclude applications', type: :feature do
    scenario 'Placeholder scenario' do
        
    end
end