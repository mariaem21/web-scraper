# By: Maria

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'
Delayed::Worker.delay_jobs = false

# User story #1 - Scraping from the STUACT website
RSpec.describe 'Scraping from STUACT', type: :feature do

    before(:all) {Organization.delete_all}
    before(:all) {ContactOrganization.delete_all}
    before(:all) {Contact.delete_all}

    before(:all) {Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')}
    before(:all) {ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)}
    before(:all) {Contact.create(contact_id: 1, year: 20_210_621, name: 'Please do not overwrite me',
            email: 'john@tamu.edu', officer_position: 'President', description: 'I should still be here after scraping')}
    
    before(:all) {Organization.create(organization_id: 2, name: 'Aggie Anglers', description: 'Unique description')}
    before(:all) {ContactOrganization.create(contact_organization_id: 2, contact_id: 2, organization_id: 2)}
    before(:all) {Contact.create(contact_id: 2, year: 20_210_621, name: 'Atlan Pfluger',
            email: 'outdated_email@tamu.edu', officer_position: 'President', description: 'My email should be updated')}

    before(:all) {Organization.create(organization_id: 3, name: 'Aggie Ballet Company', description: 'I do not have contact info yet! Please add it')}
    
    before(:all) {ScrapeJob.perform_now(["A"])}

  scenario 'Setting up for web-scraping tests' do
    OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, {
        :info =>{
          :email => 'test@tamu.edu'
        }
      })
    # Organizations created
    expect(Organization.where(organization_id: 1, name: 'A Battery', description: 'Unique description')).to exist
    expect(Organization.where(organization_id: 2, name: 'Aggie Anglers', description: 'Unique description')).to exist
    expect(Organization.where(organization_id: 3, name: 'Aggie Ballet Company', description: 'I do not have contact info yet! Please add it')).to exist

    # Contact_Organizations created
    expect(ContactOrganization.where(contact_organization_id: 1, contact_id: 1, organization_id: 1)).to exist
    expect(ContactOrganization.where(contact_organization_id: 2, contact_id: 2, organization_id: 2)).to exist
    
    # Contacts created
    expect(Contact.where(contact_id: 1, year: 20_210_621, name: 'Please do not overwrite me',
        email: 'john@tamu.edu', officer_position: 'President', description: 'I should still be here after scraping')).to exist
    expect(Contact.where(contact_id: 2, year: 20_210_621, name: 'Atlan Pfluger',
        email: 'outdated_email@tamu.edu', officer_position: 'President', description: 'My email should be updated')).to exist
    
    visit organizations_path
    sleep 5
    visit organizations_path
    # expect(page).to have_content('The database is in the process of being updated.')
  end

  scenario 'Sunny day: Starts scraping correct output (org & contact)' do
    OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, {
        :info =>{
          :email => 'test@tamu.edu'
        }
      })

    sleep 5
    # Checks has right entries for student organizations
    visit organizations_path
    expect(page).to have_content('A&M Esports') # First
    # expect(page).to have_content('Alpha Epsilon Phi Sorority') # Middle
    # expect(page).to have_content('Aggie Bridge Club') # Last

    expect(page).to have_content('Alex DeLape') # First
    expect(page).to have_content('tamu.esports.400@gmail.com')
    # expect(page).to have_content('Mia Michaels') # Middle
    # expect(page).to have_content('AggiePhiPresident@gmail.com')
    # expect(page).to have_content('ABC Voicemail Line') # Last
    # expect(page).to have_content('carter.brown@tamu.edu')
  end

  scenario 'Rainy day: does not replace old contact information' do
    OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, {
        :info =>{
          :email => 'test@tamu.edu'
        }
      })
    expect(Contact.where(contact_id: 1, year: 20_210_621, name: 'Please do not overwrite me',
        email: 'john@tamu.edu', officer_position: 'President', description: 'I should still be here after scraping')).to exist

    # New contact is created
    # new_contact_id = ContactOrganization.select{|x| x[:organization_id] == 1 && x[:contact_id] != 1}.map{|y| y[:contact_id]}
    expect(Contact.where(name: 'Chad Parker')).to exist
    expect(Contact.where(email: 'cparker@corps.tamu.edu')).to exist
  end

  scenario 'Rainy day: updates out of date organization information when both org name and contact name match' do
    OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, {
        :info =>{
          :email => 'test@tamu.edu'
        }
      })
    expect(Contact.where(contact_id: 2, year: 20_210_621, name: 'Atlan Pfluger',
        email: 'outdated_email@tamu.edu', officer_position: 'President', description: 'My email should be updated')).not_to exist

    expect(Contact.where(contact_id: 2, name: 'Atlan Pfluger',
        email: 'fishingpro@tamu.edu', officer_position: 'President')).to exist
  end

  scenario 'Rainy day: Creates new contact if organization exists and contact does not' do
    OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:google_oauth2, {
        :info =>{
          :email => 'test@tamu.edu'
        }
      })
    expect(Contact.where(name: 'Maya Sela', email: 'aggieballetco@gmail.com')).to exist
  end
end