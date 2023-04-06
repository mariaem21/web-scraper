# By: Maria

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

require 'open-uri'
require 'nokogiri'
require 'csv'
require 'date'

require 'rubygems'
# require 'test/unit'
require 'vcr'
Delayed::Worker.delay_jobs = false

VCR.configure do |config|
  vcr_mode = :once
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

# User story #1 - Scraping from the STUACT website
RSpec.describe ScrapeJob, type: :vcr do

  # org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
  # con_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
  # contact = Contact.create(contact_id: 1, year: 20_210_621, name: 'Person A',
  #                         email: 'john@tamu.edu', officer_position: 'President', description: 'Unique description')

  # let(:job_response) do
  #   letters = ["A", "Z"]
  #   VCR.use_cassette("job_run") { ScrapeJob.perform_now(letters) }
  # end

  # let(:test_A_response) do
  #   letters = ["A"]
  #   url = "https://stuactonline.tamu.edu/app/search/index/index/q/A/search/letter"
  #   VCR.use_cassette("test_data") do 
  #     html = URI.open(url).read
  #     doc = Nokogiri::HTML(html)
  # end

  # scenario 'Sunny day: Scrapes correct output (org & contact)' do

  #   # Checks has right entries for student organizations
  #   # expect(job_response).to be_kind_of(Hash)
  #   expect(job_response).to have_key(organization_id)
  #   expect(job_response).to have_key(name)

  # end

  # scenario 'Rainy day: does not replace old contact information' do
  #   visit new_organization_path
  #   org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
  #   con_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
  #   contact = Contact.create(contact_id: 1, year: 20_210_621, name: 'Person A',
  #                            email: 'john@tamu.edu', officer_position: 'President', description: 'Unique description')
  #   visit organizations_path
  #   click_on 'Scrape'
  #   visit organizations_path
  #   visit contacts_path
  #   expect(Contact.find_by(contact_id: 1).name).to eq('Person A')
  #   visit organizations_path
  #   click_on "Delete"
  # end

  # scenario 'Rainy day: updates out of date organization information when both org name and contact name match' do
  #   visit new_organization_path
  #   org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
  #   con_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
  #   contact = Contact.create(contact_id: 1, year: 20_210_621, name: 'Chad Parker',
  #                            email: 'john@tamu.edu', officer_position: 'President', description: 'Unique description')
  #   visit organizations_path
  #   click_on 'Scrape'
  #   visit organizations_path
  #   sleep 5
  #   visit contacts_path
  #   expect(Contact.find_by(contact_id: 1).email).to eq('cparker@corps.tamu.edu')
  #   visit organizations_path
  #   click_on "Delete"
  # end

  # scenario 'Rainy day: Creates new contact if organization exists and contact does not' do
  #   visit new_organization_path
  #   org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
  #   visit organizations_path
  #   click_on 'Scrape'
  #   visit organizations_path
  #   sleep 5
  #   visit contacts_path
  #   expect(page).to have_content('Chad Parker')
  #   expect(page).to have_content('cparker@corps.tamu.edu')
  #   visit organizations_path
  #   click_on "Delete"
  # end
end