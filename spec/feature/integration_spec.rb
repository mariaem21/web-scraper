# frozen_string_literal: true

# location: spec/feature/feature_spec.rb
require 'rails_helper'

# User story #1 - Scraping from the STUACT website
RSpec.describe 'Scraping from STUACT', type: :feature do

  scenario 'Rainy day: does not replace old contact information' do
    visit new_organization_path
    org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
    contact = Contact.create(personID: 1, orgID: 1, year: 20_210_621, name: 'Person A',
                             email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')
    visit organizations_path
    click_on 'Scrape'
    visit organizations_path
    visit contacts_path
    expect(Contact.find_by(personID: 1).name).to eq('Person A')
    visit organizations_path
    click_on "Delete"
  end

  scenario 'Rainy day: updates out of date organization information when both org name and contact name match' do
    visit new_organization_path
    org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
    contact = Contact.create(personID: 1, orgID: 1, year: 20_210_621, name: 'Chad Parker',
                             email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')
    visit organizations_path
    click_on 'Scrape'
    visit organizations_path
    visit contacts_path
    sleep 5
    expect(Contact.find_by(personID: 1).email).to eq('cparker@corps.tamu.edu')
    visit organizations_path
    click_on "Delete"
  end

  scenario 'Rainy day: Creates new contact if organization exists and contact does not' do
    visit new_organization_path
    org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
    visit organizations_path
    click_on 'Scrape'
    visit organizations_path
    visit contacts_path
    sleep 5
    expect(Contact.find_by(personID: 1).name).to eq('Chad Parker')
    expect(Contact.find_by(personID: 1).email).to eq('cparker@corps.tamu.edu')
    visit organizations_path
    click_on "Delete"
  end

  scenario 'Sunny day: Scrapes correct output (org & contact)' do

    # Checks has right entries for student organizations
    visit organizations_path
    click_on 'Scrape'
    visit organizations_path
    sleep 10
    expect(page).to have_content('A Battery') # First
    expect(page).to have_content('Alpha Epsilon Phi Sorority') # Middle
    expect(page).to have_content('Aggie Bridge Club') # Last

    # Checks it gets correct contact info
    visit contacts_path
    sleep 10
    expect(page).to have_content('Chad Parker') # First
    expect(page).to have_content('cparker@corps.tamu.edu')
    expect(page).to have_content('Mia Michaels') # Middle
    expect(page).to have_content('AggiePhiPresident@gmail.com')
    expect(page).to have_content('ABC Voicemail Line') # Last
    expect(page).to have_content('carter.brown@tamu.edu')

    # Deletes all entries to reset for other tests
    visit organizations_path
    click_on "Delete"
  end

  scenario 'Sunny day: Deletes everything for test purposes' do

    # Checks it deletes student org information
    visit organizations_path
    click_on 'Scrape'
    visit organizations_path
    click_on 'Delete'
    visit organizations_path
    expect(page).not_to have_content('A Battery')
    expect(page).not_to have_content('Alpha Epsilon Phi Sorority')

    # Checks it deletes contact information as well
    visit contacts_path
    expect(page).not_to have_content('Chad Parker')
    expect(page).not_to have_content('Mia Michaels')
    expect(page).not_to have_content('AggiePhiPresident@gmail.com')
  end
end

# RSpec.describe 'Downloading CSV', type: :feature do
#   scenario 'Downloads a CSV' do
#     visit organizations_path
#     click_on 'Download as CSV'
#     data = CSV.read(".../test_file.csv", return_headers: true)
#     row = data.shift()
#     expect(row).to have_content('Student Organization')
#     expect(row).to have_content('Contact Name')
#     expect(row).to have_content('Contact Email')
#     expect(row).to have_content('Officer Position')
#     expect(row).to have_content('Last Modified')
#     expect(row).to have_content('Number of Apps Built')
#     File.delete(".../test_file.csv")
#   end

#   # Checks the first and last student orgs in the STUACT wesbite & a random middle one
#   scenario '1-1 Matching: Contains (randomly selected) A Battery, Alpha Epsilon Phi Sorority, Aggie Bridge Club' do
#     visit organizations_path
#     click_on 'Download as CSV'
#     pass = 0
#     CSV.foreach(".../test_file.csv") do |row|
#       if row.include 'A Battery' 
#         pass = pass + 1
#       else if row.include 'Alpha Epsilon Phi Sorority'
#         pass = pass + 1
#       else if row.include 'Aggie Bridge Club'
#         pass = pass + 1
#       end
#     end
#     expect(pass).to equal(3)
#     File.delete(".../test_file.csv")
#   end

#   # Should: display confirmation message & not download until user confirms
#   scenario 'No student orgs selected' do
#     visit organizations_path
#     pass = 0
#     click_on 'Exclude everything' # Will need to be changed based on how filter is implemented
#     click_on 'Download as CSV'

RSpec.describe 'Editing an Existing Application', type: :feature do
    
    scenario 'valid inputs' do 
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

#         expect(page).to have_content('Invalid character types used, please only use alphanumeric and punctuation symbols.')
#     end
# end