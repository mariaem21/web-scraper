# frozen_string_literal: true

# location: spec/feature/feature_spec.rb
require 'rails_helper'

# User story #1 - Scraping from the STUACT website
# RSpec.describe 'Scraping from STUACT', type: :feature do

#   scenario 'Rainy day: does not replace old contact information' do
#     visit new_organization_path
#     org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
#     contact = Contact.create(personID: 1, orgID: 1, year: 20_210_621, name: 'Person A',
#                              email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')
#     visit organizations_path
#     click_on 'Scrape'
#     visit organizations_path
#     visit contacts_path
#     expect(Contact.find_by(personID: 1).name).to eq('Person A')
#     visit organizations_path
#     click_on "Delete"
#   end

#   scenario 'Rainy day: updates out of date organization information when both org name and contact name match' do
#     visit new_organization_path
#     org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
#     contact = Contact.create(personID: 1, orgID: 1, year: 20_210_621, name: 'Chad Parker',
#                              email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')
#     visit organizations_path
#     click_on 'Scrape'
#     visit organizations_path
#     visit contacts_path
#     sleep 5
#     expect(Contact.find_by(personID: 1).email).to eq('cparker@corps.tamu.edu')
#     visit organizations_path
#     click_on "Delete"
#   end

#   scenario 'Rainy day: Creates new contact if organization exists and contact does not' do
#     visit new_organization_path
#     org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
#     visit organizations_path
#     click_on 'Scrape'
#     visit organizations_path
#     visit contacts_path
#     sleep 5
#     expect(Contact.find_by(personID: 1).name).to eq('Chad Parker')
#     expect(Contact.find_by(personID: 1).email).to eq('cparker@corps.tamu.edu')
#     visit organizations_path
#     click_on "Delete"
#   end

#   scenario 'Sunny day: Scrapes correct output (org & contact)' do

#     # Checks has right entries for student organizations
#     visit organizations_path
#     click_on 'Scrape'
#     visit organizations_path
#     sleep 10
#     expect(page).to have_content('A Battery') # First
#     expect(page).to have_content('Alpha Epsilon Phi Sorority') # Middle
#     expect(page).to have_content('Aggie Bridge Club') # Last

#     # Checks it gets correct contact info
#     visit contacts_path
#     sleep 10
#     expect(page).to have_content('Chad Parker') # First
#     expect(page).to have_content('cparker@corps.tamu.edu')
#     expect(page).to have_content('Mia Michaels') # Middle
#     expect(page).to have_content('AggiePhiPresident@gmail.com')
#     expect(page).to have_content('ABC Voicemail Line') # Last
#     expect(page).to have_content('carter.brown@tamu.edu')

#     # Deletes all entries to reset for other tests
#     visit organizations_path
#     click_on "Delete"
#   end

#   scenario 'Sunny day: Deletes everything for test purposes' do

#     # Checks it deletes student org information
#     visit organizations_path
#     click_on 'Scrape'
#     visit organizations_path
#     click_on 'Delete'
#     visit organizations_path
#     expect(page).not_to have_content('A Battery')
#     expect(page).not_to have_content('Alpha Epsilon Phi Sorority')

#     # Checks it deletes contact information as well
#     visit contacts_path
#     expect(page).not_to have_content('Chad Parker')
#     expect(page).not_to have_content('Mia Michaels')
#     expect(page).not_to have_content('AggiePhiPresident@gmail.com')
#   end
# end

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
#     # Check the confirmation message appears
#     expect(page).to have_content("You are downloading a blank CSV file. Do you wish to proceed?")
#     click_on 'Yes'

#     # Check the CSV downloads the correct number of rows
#     CSV.foreach(".../test_file.csv") do |row|
#       pass = pass + 1
#     end

#     # Check the CSV contains the right header attributes
#     data = CSV.read(".../test_file.csv", return_headers: true)
#     row = data.shift()
#     expect(row).to have_content('Student Organization')
#     expect(row).to have_content('Contact Name')
#     expect(row).to have_content('Contact Email')
#     expect(row).to have_content('Officer Position')
#     expect(row).to have_content('Last Modified')
#     expect(row).to have_content('Number of Apps Built')
#     expect(pass).to equal(1) # Should only have the header row
#     File.delete(".../test_file.csv")
#   end

#   scenario 'Wait message pops up before 5 seconds have elapsed & disappears after finishing download' do
#     visit organizations_path
#     start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
#     click_on 'Download as CSV'
#     expect(page).to have_content("Your file is downloading")
#     end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
#     elapsed = end_time - start_time
#     expect(elapsed).to be < 5
#     data = CSV.read(".../test_file.csv", return_headers: true)
#     expect(page).to_not have_content("Your file is downloading")
#     File.delete(".../test_file.csv")
#   end
# end

##### Someone else's tests! ######

# RSpec.describe 'Downloading CSV with exclusions', type: :feature do
#     scenario 'No Exclusion' do
#         visit organizations_path
#         click_on 'Scrape'
#         click_on 'Download CSV'
#         click_on 'Download Full CSV'
#         #verify csv has all columns 
#         data=CSV.read("../test_file.csv",return_headers: true)
#         row=data.shift
#         expect(row).to have_content('Org')
#         expect(row).to have_content('Link')
#         expect(row).to have_content('Email')
#         expect(row).to have_content('Contact')
#         File.delete("../test_file.csv")
#     end

#     scenario 'Some Exclusion' do
#         visit organizations_path
#         click_on 'Scrape'
#         click_on 'Download CSV'
#         click_on 'excludeOrgName'
#         click_on 'excludeContactName'
#         #verify csv does not have collumn
#         data=CSV.read("../test_file.csv",return_headers: true)
#         row=data.shift
#         expect(row).to have_content('Link')
#         expect(row).to have_content('Email')
#         File.delete("../test_file.csv")
#     end

#     scenario 'All Excluded' do
#         visit organizations_path
#         click_on 'Scrape'
#         click_on 'Download CSV'
#         #exclude all columns
#         click_on 'excludeOrgName'
#         click_on 'excludeLink'
#         click_on 'excludeContactName'
#         click_on 'excludeEmail'
#         #verify csv not downloaded
#         expect(File.exists?(file_name)).to eq(false)
#         #verify error message
#         expect(page).to have_content('CSV Cannot Be Empty')
#     end
# end


# RSpec.describe 'Editing an Existing Application', type: :feature do
    
#     scenario 'valid inputs' do 
#       org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
#       org = Organization.create(orgID: 2, name: 'B Battery', description: 'Unique description')
#         visit applications_path
#         click_on 'New application'
#         fill_in "application[name]", with: 'Test Application'
#         fill_in "application[orgID]", with: '01'
#         fill_in "application[applicationID]", with: '01'
#         fill_in "application[datebuilt]", with: '01-01-2001'
#         fill_in "application[githublink]", with: 'www.github.com'
#         fill_in "application[description]", with: 'test description'        

#         click_on 'Create Application'
#         click_link 'Edit'
#         fill_in "application[name]", with: 'Test Application2'
#         fill_in "application[orgID]", with: '02'
#         fill_in "application[applicationID]", with: '02'
#         click_on 'Update Application'
#         expect(page).to have_content('Application was successfully updated.')
#     end
 
#     scenario 'Blank inputs' do 
#       org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
#       org = Organization.create(orgID: 2, name: 'B Battery', description: 'Unique description')
#         visit applications_path
#         click_on 'New application'
#         fill_in "application[name]", with: 'Test Application'
#         fill_in "application[orgID]", with: '01'
#         fill_in "application[applicationID]", with: '01'
#         fill_in "application[datebuilt]", with: '01-01-2001'
#         fill_in "application[githublink]", with: 'www.github.com'
#         fill_in "application[description]", with: 'test description'  

#         click_on 'Create Application'
#         click_link 'Edit'
#         fill_in "application[name]", with: ' '
#         click_on 'Update Application'
#         expect(page).to have_content('Name can\'t be blank')
#     end

#     scenario 'Irregular inputs' do 
#       org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
#       org = Organization.create(orgID: 2, name: 'B Battery', description: 'Unique description')
#         visit applications_path
#         click_on 'New application'
#         fill_in "application[name]", with: 'Test Application'
#         fill_in "application[orgID]", with: '01'
#         fill_in "application[applicationID]", with: '01'
#         fill_in "application[datebuilt]", with: '01-01-2001'
#         fill_in "application[githublink]", with: 'www.github.com'
#         fill_in "application[description]", with: 'test description'  
#         click_on 'Create Application'
#         click_link 'Edit'
#         fill_in "application[name]", with: 'テスト・アップ12▌╚X8_á⌂╛5'
#         click_on 'Update Application'


#         expect(page).to have_content('Application was successfully updated.')
#     end
# end

# New application request integration tests

# User Variables
# Application Developed | Contact Name | Contact Email | Officer Position | Github Link | Year Developed | Notes

RSpec.describe 'New valid application requests', type: :feature do
  scenario 'Adding valid application | Should add new application to database and view section' do
    visit new_organization_path
    org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
    contact = Contact.create(personID: 1, orgID: 1, year: '02-24-2023', name: 'Person A',
                             email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')

    visit applications_path
    click_on 'New application'
    fill_in 'application[applicationID]', with: '1'
    fill_in 'application[orgID]', with: '1'
    fill_in 'application[name]', with: 'Valid application'
    fill_in 'application[datebuilt]', with: 20_210_621
    fill_in 'application[githublink]', with: 'github.com'
    fill_in 'application[description]', with: 'First application test'
    click_on 'Create Application'
    expect(page).to have_content('Valid application')
  end
end

RSpec.describe 'Invalid application information request', type: :feature do
  scenario 'Invalid github link and description | Should have a popup with information warning about each invalid field' do
    visit new_organization_path
    org = Organization.create(orgID: 2, name: 'Test org 2', description: 'description')
    contact = Contact.create(personID: 1, orgID: 2, year: '02-24-2023', name: 'Person A',
                             email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')

    visit applications_path
    click_on 'New application'
    fill_in 'application[applicationID]', with: '2'
    fill_in 'application[orgID]', with: '2'
    fill_in 'application[name]', with: 'Invalid application'
    fill_in 'application[datebuilt]', with: 20_210_621
    # fill_in 'application[githublink]', with: ''
    # fill_in 'application[description]', with: ''
    click_on 'Create Application'
    expect(page).to have_content('errors prohibited this application from being saved:')
    expect(page).to have_content('Githublink can\'t be blank')
    expect(page).to have_content('Description can\'t be blank')
  end

  scenario 'Invalid name and date built', type: :feature do
    visit applications_path
    click_on 'New application'
    fill_in 'application[applicationID]', with: '2'
    fill_in 'application[orgID]', with: '2'
    fill_in 'application[name]', with: ''
    fill_in 'application[datebuilt]', with: ''
    fill_in 'application[githublink]', with: 'github.com'
    fill_in 'application[description]', with: 'invalid test app'
    click_on 'Create Application'
    expect(page).to have_content('errors prohibited this application from being saved:')
    expect(page).to have_content('Name can\'t be blank')
    expect(page).to have_content('Datebuilt can\'t be blank')
  end
end

RSpec.describe 'Negative applicationID', type: :feature do
  scenario 'Negative applicationID | Should have a popup with information warning' do
    visit new_organization_path
    org = Organization.create(orgID: 3, name: 'Test org 3', description: 'description')
    contact = Contact.create(personID: 1, orgID: 3, year: '02-24-2023', name: 'Person A',
                             email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')

    visit applications_path
    click_on 'New application'
    fill_in 'application[applicationID]', with: '-1'
    fill_in 'application[orgID]', with: '3'
    fill_in 'application[name]', with: 'Invalid applicationID'
    fill_in 'application[datebuilt]', with: 20_210_621
    fill_in 'application[githublink]', with: 'github.com'
    fill_in 'application[description]', with: 'Invalid applicationID desc'
    click_on 'Create Application'
    expect(page).to have_content('error prohibited this application from being saved:')
    expect(page).to have_content('Applicationid cannot be less than 1')
  end
end

RSpec.describe 'Non existing orgID', type: :feature do
  scenario 'Non existing orgID | Should have a popup with information warning' do
    visit applications_path
    click_on 'New application'
    fill_in 'application[applicationID]', with: '4'
    fill_in 'application[orgID]', with: '10'
    fill_in 'application[name]', with: 'Non existing orgID'
    fill_in 'application[datebuilt]', with: 20_210_621
    fill_in 'application[githublink]', with: 'github.com'
    fill_in 'application[description]', with: 'Non existing orgID desc'
    click_on 'Create Application'
    expect(page).to have_content('error prohibited this application from being saved:')
    expect(page).to have_content('Orgid must have a valid organization ID')
  end
end

RSpec.describe 'Negative orgID', type: :feature do
  scenario 'Negative orgID | Should have a popup with information warning' do
    visit applications_path
    click_on 'New application'
    fill_in 'application[applicationID]', with: '5'
    fill_in 'application[orgID]', with: '-1'
    fill_in 'application[name]', with: 'Invalid orgID'
    fill_in 'application[datebuilt]', with: 20_210_621
    fill_in 'application[githublink]', with: 'github.com'
    fill_in 'application[description]', with: 'Invalid orgID desc'
    click_on 'Create Application'
    expect(page).to have_content('error prohibited this application from being saved:')
    expect(page).to have_content('Orgid must have a valid organization ID')
    expect(page).to have_content('Orgid cannot be less than 1')
  end
end
