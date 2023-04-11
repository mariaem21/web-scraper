# By: Alan

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

# Exclude organizations from list of potential customers integration tests

RSpec.describe 'Exclude organizations', type: :feature do
    scenario 'Add application and exclude' do
        visit organizations_path

        # page.fill_in ('org_name', with: 'Test Organization')
        # page.fill_in ('contact_name', with: 'Alan Enriquez')
        # page.fill_in ('contact_email', with: 'age2001@tamu.edu')
        # page.fill_in ('officer_position', with: 'President')

        fill_in ('org_name', with: 'Test Organization')
        fill_in ('contact_name', with: 'Alan Enriquez')
        fill_in ('contact_email', with: 'age2001@tamu.edu')
        fill_in ('officer_position', with: 'President')

        expect(page).to have_content('Test Organization')
        expect(page).to have_content('Alan Enriquez')
        expect(page).to have_content('age2001@tamu.edu')
        expect(page).to have_content('President')

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