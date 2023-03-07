# By: Tripper

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'


RSpec.describe 'Editing an Existing Application', type: :feature do
    
    scenario 'valid inputs' do 
      org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
      org = Organization.create(orgID: 2, name: 'B Battery', description: 'Unique description')
        visit applications_path
        click_on 'New application'
        fill_in "application[name]", with: 'Test Application'
        fill_in "application[orgID]", with: '01'
        fill_in "application[applicationID]", with: '01'
        fill_in "application[datebuilt]", with: '01-01-2001'
        fill_in "application[githublink]", with: 'www.github.com'
        fill_in "application[description]", with: 'test description'        

        click_on 'Create Application'
        click_link 'Edit'
        fill_in "application[name]", with: 'Test Application2'
        fill_in "application[orgID]", with: '02'
        fill_in "application[applicationID]", with: '02'
        click_on 'Update Application'
        expect(page).to have_content('Application was successfully updated.')
    end
 
    scenario 'Blank inputs' do 
      org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
      org = Organization.create(orgID: 2, name: 'B Battery', description: 'Unique description')
        visit applications_path
        click_on 'New application'
        fill_in "application[name]", with: 'Test Application'
        fill_in "application[orgID]", with: '01'
        fill_in "application[applicationID]", with: '01'
        fill_in "application[datebuilt]", with: '01-01-2001'
        fill_in "application[githublink]", with: 'www.github.com'
        fill_in "application[description]", with: 'test description'  

        click_on 'Create Application'
        click_link 'Edit'
        fill_in "application[name]", with: ' '
        click_on 'Update Application'
        expect(page).to have_content('Name can\'t be blank')
    end

    scenario 'Irregular inputs' do 
      org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
      org = Organization.create(orgID: 2, name: 'B Battery', description: 'Unique description')
        visit applications_path
        click_on 'New application'
        fill_in "application[name]", with: 'Test Application'
        fill_in "application[orgID]", with: '01'
        fill_in "application[applicationID]", with: '01'
        fill_in "application[datebuilt]", with: '01-01-2001'
        fill_in "application[githublink]", with: 'www.github.com'
        fill_in "application[description]", with: 'test description'  
        click_on 'Create Application'
        click_link 'Edit'
        fill_in "application[name]", with: 'テスト・アップ12▌╚X8_á⌂╛5'
        click_on 'Update Application'


        expect(page).to have_content('Application was successfully updated.')
    end
end