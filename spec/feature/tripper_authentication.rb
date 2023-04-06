# By: Tripper

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'
RSpec.describe 'Testing Authentication And URL Protection', type: :feature do
    scenario 'Valid Tamu Email' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
          :info =>{
            :email => 'test@tamu.edu'
          }
        })
        visit admin_google_oauth2_omniauth_authorize_path
        visit organizations_path
        expect(page).to have_content('Organization')
    end

    scenario 'Valid non-Tamu Email' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
          :info =>{
            :email => 'test@gmail.com'
          }
        })
        visit admin_google_oauth2_omniauth_authorize_path
        visit organizations_path
        expect(page).to have_content('sign in')
    end

    scenario 'Invalid Email' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
          :info =>{
            :email => 'totallyanemail'
          }
        })
        visit admin_google_oauth2_omniauth_authorize_path
        visit organizations_path
        expect(page).to have_content('sign in')
    end

    scenario 'Direct URL Accessing' do
        visit organizations_path
        expect(page).to have_content('sign in')
    end
end