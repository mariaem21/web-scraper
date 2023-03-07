# By: Tripper

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

RSpec.describe 'Downloading CSV with exclusions', type: :feature do
    scenario 'No Exclusion' do
        visit organizations_path
        click_on 'Scrape'
        click_on 'Download as CSV'
        click_on 'Download Full CSV'
        #verify csv has all columns 
        data=CSV.read("../test_file.csv",return_headers: true)
        row=data.shift
        expect(row).to have_content('Org')
        expect(row).to have_content('Link')
        expect(row).to have_content('Email')
        expect(row).to have_content('Contact')
        File.delete("../test_file.csv")
    end
    
    scenario 'Some Exclusion' do
        visit organizations_path
        click_on 'Scrape'
        click_on 'Download as CSV'
        click_on 'excludeOrgName'
        click_on 'excludeContactName'
        #verify csv does not have collumn
        data=CSV.read("../test_file.csv",return_headers: true)
        row=data.shift
        expect(row).to have_content('Link')
        expect(row).to have_content('Email')
        File.delete("../test_file.csv")
    end
    
    scenario 'All Excluded' do
        visit organizations_path
        click_on 'Scrape'
        click_on 'Download as CSV'
        #exclude all columns
        click_on 'excludeOrgName'
        click_on 'excludeLink'
        click_on 'excludeContactName'
        click_on 'excludeEmail'
        #verify csv not downloaded
        expect(File.exists?(file_name)).to eq(false)
        #verify error message
        expect(page).to have_content('CSV Cannot Be Empty')
    end
end