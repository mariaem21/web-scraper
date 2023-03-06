# By: Maria

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'
Delayed::Worker.delay_jobs = false

# User story #1 - Scraping from the STUACT website
RSpec.describe 'Scraping from STUACT', type: :feature do

  scenario 'Sunny day: Scrapes correct output (org & contact)' do

    # Checks has right entries for student organizations
    visit organizations_path
    click_on 'Scrape'
    sleep 20
    visit organizations_path
    sleep 5
    expect(page).to have_content('A&M Esports') # First
    # expect(page).to have_content('Alpha Epsilon Phi Sorority') # Middle
    # expect(page).to have_content('Aggie Bridge Club') # Last

    # Checks it gets correct contact info
    visit contacts_path
    expect(page).to have_content('Alex DeLape') # First
    expect(page).to have_content('tamu.esports.400@gmail.com')
    # expect(page).to have_content('Mia Michaels') # Middle
    # expect(page).to have_content('AggiePhiPresident@gmail.com')
    # expect(page).to have_content('ABC Voicemail Line') # Last
    # expect(page).to have_content('carter.brown@tamu.edu')

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

  scenario 'Rainy day: does not replace old contact information' do
    visit new_organization_path
    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
    contact = Contact.create(contact_id: 1, organization_id: 1, year: 20_210_621, name: 'Person A',
                             email: 'john@tamu.edu', officer_position: 'President', description: 'Unique description')
    visit organizations_path
    click_on 'Scrape'
    visit organizations_path
    visit contacts_path
    expect(Contact.find_by(contact_id: 1).name).to eq('Person A')
    visit organizations_path
    click_on "Delete"
  end

  scenario 'Rainy day: updates out of date organization information when both org name and contact name match' do
    visit new_organization_path
    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
    contact = Contact.create(contact_id: 1, organization_id: 1, year: 20_210_621, name: 'Chad Parker',
                             email: 'john@tamu.edu', officer_position: 'President', description: 'Unique description')
    visit organizations_path
    click_on 'Scrape'
    visit organizations_path
    sleep 5
    visit contacts_path
    expect(Contact.find_by(organization_id: 1).email).to eq('cparker@corps.tamu.edu')
    visit organizations_path
    click_on "Delete"
  end

  scenario 'Rainy day: Creates new contact if organization exists and contact does not' do
    visit new_organization_path
    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
    visit organizations_path
    click_on 'Scrape'
    visit organizations_path
    sleep 5
    visit contacts_path
    expect(Contact.find_by(organization_id: 1).name).to eq('Chad Parker')
    expect(Contact.find_by(organization_id: 1).email).to eq('cparker@corps.tamu.edu')
    visit organizations_path
    click_on "Delete"
  end
end