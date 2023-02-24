# frozen_string_literal: true

# location: spec/feature/feature_spec.rb
require 'rails_helper'

# User story #1 - Scraping from the STUACT website
RSpec.describe 'Scraping from STUACT', type: :feature do
  scenario 'Scrapes correct output for organization' do
    visit organizations_path
    click_on 'Scrape'
    expect(page).to have_content('A Battery')
    expect(page).to have_content('Alpha Epsilon Phi Sorority')
  end

  scenario 'Scrapes correct output for contact info' do
    visit organizations_path
    click_on 'Scrape'
    visit contacts_path
    expect(page).to have_content('Chad Parker')
    expect(page).to have_content('Mia Michaels')
    expect(page).to have_content('AggiePhiPresident@gmail.com')
  end

  scenario 'Has correct number of entries (Same as STUACT)' do
    visit organizations_path
    click_on 'Scrape'
    expect(page).to have_content('500')
  end

  scenario 'Deletes everything (org) for test purposes' do
    visit organizations_path
    click_on 'Scrape'
    click_on 'Delete Results'
    expect(page).not_to have_content('A Battery')
    expect(page).not_to have_content('Alpha Epsilon Phi Sorority')
  end

  scenario 'Deletes everything (contact) for test purposes' do
    visit organizations_path
    click_on 'Scrape'
    click_on 'Delete Results'
    visit contacts_path
    expect(page).not_to have_content('Chad Parker')
    expect(page).not_to have_content('Mia Michaels')
    expect(page).not_to have_content('AggiePhiPresident@gmail.com')
  end

  scenario 'correct output for first org in STUACT with all attributes' do
    visit organizations_path
    click_on 'Scrape'
    expect(page).to have_content('A Battery')
    visit contacts_path
    expect(page).to have_content('Chad Parker')
    expect(page).to have_content('cparker@corps.tamu.edu')
  end

  scenario 'correct output for middle org in STUACT with all attributes' do
    visit organizations_path
    click_on 'Scrape'
    expect(page).to have_content('Alpha Epsilon Phi Sorority')
    visit contacts_path
    expect(page).to have_content('Mia Michaels')
    expect(page).to have_content('AggiePhiPresident@gmail.com')
  end

  scenario 'correct output for middle org in STUACT without all attributes' do
    visit organizations_path
    click_on 'Scrape'
    expect(page).to have_content('Aggie Art Therapy Association')
    visit contacts_path
    expect(page).to have_content('')
    expect(page).to have_content('')
  end

  scenario 'updates out of date organization information' do
    visit new_organization_path
    org = Organization.create(orgID: 1, name: 'A Battery', description: 'Unique description')
    contact = Contact.create(personID: 1, orgID: 1, year: 20_210_621, name: 'Person A',
                             email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')
    visit organizations_path
    click_on 'Scrape'
    visit organizations_path
    expect(contact.name).to eql 'Chad Parker'
  end
end

RSpec.describe 'Downloading CSV', type: :feature do
  scenario 'Downloads a CSV' do
    visit organizations_path
    click_on 'Download as CSV'
    data = CSV.read(".../test_file.csv", return_headers: true)
    row = data.shift()
    expect(row).to have_content('Student Organization')
    expect(row).to have_content('Contact Name')
    expect(row).to have_content('Contact Email')
    expect(row).to have_content('Officer Position')
    expect(row).to have_content('Last Modified')
    expect(row).to have_content('Number of Apps Built')
    File.delete(".../test_file.csv")
  end

  # Checks the first and last student orgs in the STUACT wesbite & a random middle one
  scenario '1-1 Matching: Contains (randomly selected) A Battery, Alpha Epsilon Phi Sorority, Aggie Bridge Club' do
    visit organizations_path
    click_on 'Download as CSV'
    pass = 0
    CSV.foreach(".../test_file.csv") do |row|
      if row.include 'A Battery' 
        pass = pass + 1
      else if row.include 'Alpha Epsilon Phi Sorority'
        pass = pass + 1
      else if row.include 'Aggie Bridge Club'
        pass = pass + 1
      end
    end
    expect(pass).to equal(3)
    File.delete(".../test_file.csv")
  end

  # Should: display confirmation message & not download until user confirms
  scenario 'No student orgs selected' do
    visit organizations_path
    pass = 0
    click_on 'Exclude everything' # Will need to be changed based on how filter is implemented
    click_on 'Download as CSV'
    
    # Check the confirmation message appears
    expect(page).to have_content("You are downloading a blank CSV file. Do you wish to proceed?")
    click_on 'Yes'
    
    # Check the CSV downloads the correct number of rows
    CSV.foreach(".../test_file.csv") do |row|
      pass = pass + 1
    end
    
    # Check the CSV contains the right header attributes
    data = CSV.read(".../test_file.csv", return_headers: true)
    row = data.shift()
    expect(row).to have_content('Student Organization')
    expect(row).to have_content('Contact Name')
    expect(row).to have_content('Contact Email')
    expect(row).to have_content('Officer Position')
    expect(row).to have_content('Last Modified')
    expect(row).to have_content('Number of Apps Built')
    expect(pass).to equal(1) # Should only have the header row
    File.delete(".../test_file.csv")
  end

  scenario 'Wait message pops up before 5 seconds have elapsed & disappears after finishing download' do
    visit organizations_path
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    click_on 'Download as CSV'
    expect(page).to have_content("Your file is downloading")
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = end_time - start_time
    expect(elapsed).to be < 5
    data = CSV.read(".../test_file.csv", return_headers: true)
    expect(page).to_not have_content("Your file is downloading")
    File.delete(".../test_file.csv")
  end
end
