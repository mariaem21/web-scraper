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

RSpec.describe 'Editing an Application', type: :feature do
    
    scenario 'valid inputs' do 
        visit application_path
        click_on 'Edit Application'
        fill_in "application[Name]", with: 'Test Application'
        fill_in "application[Type]", with: 'Web'
        fill_in "application[Notes]", with: 'Noting of Note'
        click_on 'Confirm Changes'
        expect(page).to have_content('Application was successfully Edited.')
    end
 
    scenario 'Blank inputs' do 
        visit application_path
        click_on 'Edit Application'
        click_on 'Confirm Changes'
        expect(page).to have_content('Edits Cannot Be Blank')
    end

    scenario 'Invalid inputs' do 
        visit application_path
        click_on 'Edit Application'
        fill_in "application[Name]", with: 'テスト・アップ'
        fill_in "application[Notes]", with: '!@#$%^&*()'
        fill_in "application[Type]", with: '12▌╚X8_á⌂╛5'
        click_on 'Confirm Changes'

        expect(page).to have_content('Invalid character types used, please only use alphanumeric and punctuation symbols.')
    end

end