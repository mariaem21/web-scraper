
# By: Tripper

require 'rails_helper'

#RSpec.describe 'Organizations Filtering', type: :feature do
#    scenario 'Filtering by name with wildcard, then filter by email ' do
#        OmniAuth.config.test_mode = true
#        OmniAuth.config.add_mock(:google_oauth2, {
#          :info =>{
#            :email => 'test@tamu.edu'
#          }
#        })
#        visit admin_google_oauth2_omniauth_authorize_path
#        visit organizations_path
#        fill_in 'name_search', with: "_&M"
#        expect(page).to have_content("A&M Photography Club")
#        
#        fill_in 'contact_name_search', with:"Bryan"
#        expect(page).to_not have_content("A&M Photography Club")
#        expect(page).to have_content("A&M United Methodist Church's College Ministry")
#    end
#end