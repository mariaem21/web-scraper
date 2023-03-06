# By: Tripper

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

RSpec.describe 'Editing an Existing Application', type: :feature do
    
    scenario 'valid inputs' do 
      org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
      org = Organization.create(organization_id: 2, name: 'B Battery', description: 'Unique description')
        visit applications_path
        click_on 'New application'
        fill_in "application[name]", with: 'Test Application'
        fill_in "application[organization_id]", with: '01'
        fill_in "application[application_id]", with: '01'
        fill_in "application[date_built]", with: '01-01-2001'
        fill_in "application[github_link]", with: 'www.github.com'
        fill_in "application[description]", with: 'test description'        

        click_on 'Create Application'
        click_link 'Edit'
        fill_in "application[name]", with: 'Test Application2'
        fill_in "application[organization_id]", with: '02'
        fill_in "application[application_id]", with: '02'
        click_on 'Update Application'
        expect(page).to have_content('Application was successfully updated.')
    end

    scenario 'Blank inputs' do 
      org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
      org = Organization.create(organization_id: 2, name: 'B Battery', description: 'Unique description')
        visit applications_path
        click_on 'New application'
        fill_in "application[name]", with: 'Test Application'
        fill_in "application[organization_id]", with: '01'
        fill_in "application[application_id]", with: '01'
        fill_in "application[date_built]", with: '01-01-2001'
        fill_in "application[github_link]", with: 'www.github.com'
        fill_in "application[description]", with: 'test description'  

        click_on 'Create Application'
        click_link 'Edit'
        fill_in "application[name]", with: ' '
        click_on 'Update Application'
        expect(page).to have_content('Name can\'t be blank')
    end

    scenario 'Irregular inputs' do 
      org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
      org = Organization.create(organization_id: 2, name: 'B Battery', description: 'Unique description')
        visit applications_path
        click_on 'New application'
        fill_in "application[name]", with: 'Test Application'
        fill_in "application[organization_id]", with: '01'
        fill_in "application[application_id]", with: '01'
        fill_in "application[date_built]", with: '01-01-2001'
        fill_in "application[github_link]", with: 'www.github.com'
        fill_in "application[description]", with: 'test description'  
        click_on 'Create Application'
        click_link 'Edit'
        fill_in "application[name]", with: 'テスト・アップ12▌╚X8_á⌂╛5'
        click_on 'Update Application'


        expect(page).to have_content('Application was successfully updated.')
    end
end
