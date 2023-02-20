# location: spec/feature/feature_spec.rb
require 'rails_helper'

RSpec.describe 'Scraping from STUACT', type: :feature do
    scenario 'Scrapes correct output for organization' do
        visit organizations_path
        click_on "Scrape" 
        expect(page).to have_content('A Battery')
        expect(page).to have_content('Alpha Epsilon Phi Sorority')
    end

    scenario 'Scrapes correct output for contact info' do
        visit organizations_path
        click_on "Scrape" 
        visit contacts_path
        expect(page).to have_content('Chad Parker')
        expect(page).to have_content('Mia Michaels')
        expect(page).to have_content('AggiePhiPresident@gmail.com')
    end

    scenario 'Has correct number of entries (Same as STUACT)' do
        visit organizations_path
        click_on "Scrape"
        expect(page).to have_content('500')
    end

    scenario 'Deletes everything (org) for test purposes' do
        visit organizations_path
        click_on "Scrape" 
        click_on "Delete Results"
        expect(page).not_to have_content('A Battery')
        expect(page).not_to have_content('Alpha Epsilon Phi Sorority')
    end

    scenario 'Deletes everything (contact) for test purposes' do
        visit organizations_path
        click_on "Scrape" 
        click_on "Delete Results"
        visit contacts_path
        expect(page).not_to have_content('Chad Parker')
        expect(page).not_to have_content('Mia Michaels')
        expect(page).not_to have_content('AggiePhiPresident@gmail.com')
    end

    scenario 'correct output for first org in STUACT with all attributes' do
        visit organizations_path
        click_on "Scrape" 
        expect(page).to have_content('A Battery')
        visit contacts_path
        expect(page).to have_content('Chad Parker')
        expect(page).to have_content('cparker@corps.tamu.edu')
    end

    scenario 'correct output for middle org in STUACT with all attributes' do
        visit organizations_path
        click_on "Scrape"
        expect(page).to have_content('Alpha Epsilon Phi Sorority')
        visit contacts_path
        expect(page).to have_content('Mia Michaels')
        expect(page).to have_content('AggiePhiPresident@gmail.com')
    end

    scenario 'correct output for middle org in STUACT without all attributes' do
        visit organizations_path
        click_on "Scrape"
        expect(page).to have_content('Aggie Art Therapy Association')
        visit contacts_path
        expect(page).to have_content('')
        expect(page).to have_content('')
    end

    scenario 'updates out of date organization information' do
        visit new_organization_path
        org = Organization.create(:orgID => 1, :name => "A Battery", :description => "Unique description")
        contact = Contact.create(:personID => 1, :orgID => 1, :year => 20210621, :name => "Person A", :email => "john@tamu.edu", :officerposition => "President", :description => "Unique description")
        visit organizations_path
        click_on "Scrape"
        visit organizations_path
        expect(contact.name).to eql "Chad Parker"
    end
end