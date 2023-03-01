# location: spec/feature/integration_spec.rb
require 'rails_helper'

RSpec.describe 'Scraping from STUACT', type: :feature do
    scenario 'correct output' do
        visit student_orgs_url
        # click_on "Scrape"
        # expect(page).to have_content('')
    end
end

RSpec.describe 'Downloading CSV with exclusions', type: :feature do
    scenario 'No Exclusion' do
        visit organizations_path
        click_on 'Scrape'
        click_on 'Download CSV'
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
        click_on 'Download CSV'
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
        click_on 'Download CSV'
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

RSpec.describe 'Editing an Existing Application', type: :feature do
    
    scenario 'valid inputs' do 
        visit applications_path
        click_on 'New application'
        fill_in "application[name]", with: 'Test Application'
        fill_in "application[orgID]", with: '01'
        fill_in "application[applicationID]", with: '01'
        click_on 'Create Application'
        click_link 'Edit'
        fill_in "application[name]", with: 'Test Application2'
        fill_in "application[orgID]", with: '02'
        fill_in "application[applicationID]", with: '02'
        click_on 'Update Application'
        expect(page).to have_content('Application was successfully updated.')
    end
 
    scenario 'Blank inputs' do 
        visit applications_path
        click_on 'New application'
        fill_in "application[name]", with: 'Test Application'
        fill_in "application[orgID]", with: '01'
        fill_in "application[applicationID]", with: '01'
        click_on 'Create Application'
        click_link 'Edit'
        fill_in "application[name]", with: ' '
        click_on 'Update Application'
        expect(page).to have_content('Name can\'t be blank')
    end

    scenario 'Irregular inputs' do 
        visit applications_path
        click_on 'New application'
        fill_in "application[name]", with: 'Test Application'
        fill_in "application[orgID]", with: '01'
        fill_in "application[applicationID]", with: '01'
        click_on 'Create Application'
        click_link 'Edit'
        fill_in "application[name]", with: 'テスト・アップ12▌╚X8_á⌂╛5'
        click_on 'Update Application'

        expect(page).to have_content('Application was successfully updated.')
    end

end