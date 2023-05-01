# By: Maria

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'
Delayed::Worker.delay_jobs = false

# User story #1 - Scraping from the STUACT website
RSpec.describe 'Scraping from STUACT', type: :feature do
    before(:all) {

      ###############################################################################################
      # CHECK THESE VALUES BEFORE RUNNING TEST ######################################################
      ###############################################################################################

      # For each organization below, do the following:
      #
      #   1) Using Ctrl+F, check & make sure @<number>_organization_name are in STUACT at this link: 
      #         https://stuactonline.tamu.edu/app/search/index/index/q/a/search/letter
      #
      #   2) Click on student organization
      #   3) Make sure Public Contact Name & Public Contact E-mail Address match the ones below
      
      # 1st Organization 
      @first_organization_name = 'A Battery'
      @first_public_contact_name = 'Chad Parker'
      @first_public_contact_email = 'cparker@corps.tamu.edu'

      # 2nd Organization 
      @second_organization_name = 'Aggie Anglers'
      @second_public_contact_name = 'Atlan Pfluger'
      @second_public_contact_email = 'fishingpro@tamu.edu'

      # 3rd Organization
      @third_organization_name = 'Aggie Ballet Company'
      @third_public_contact_name = 'Maya Sela'
      @third_public_contact_email = 'aggieballetco@gmail.com'

      # 4th Organization 
      @random_organization_name = 'A&M Esports'
      @random_public_contact_name = 'Alex DeLape'
      @random_public_contact_email = 'tamu.esports.400@gmail.com'

      ##################################################################################################
      # END OF SECTION #################################################################################
      ##################################################################################################

      # Delete everything
      Organization.delete_all
      ContactOrganization.delete_all
      Contact.delete_all

      # Create 1st organization
      Organization.create(organization_id: 1, name: @first_organization_name, description: 'Unique description')
      ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
      Contact.create(contact_id: 1, year: 20_210_621, name: 'Please do not overwrite me',
            email: 'john@tamu.edu', officer_position: 'President', description: 'I should still be here after scraping')

      # Create 2nd organization
      Organization.create(organization_id: 2, name: @second_organization_name, description: 'Unique description')
      ContactOrganization.create(contact_organization_id: 2, contact_id: 2, organization_id: 2)
      Contact.create(contact_id: 2, year: 20_210_621, name: @second_public_contact_name,
            email: 'outdated_email@tamu.edu', officer_position: 'President', description: 'My email should be updated')

      # Create 3rd organization
      Organization.create(organization_id: 3, name: @third_organization_name, description: 'I do not have contact info yet! Please add it')

      # After everything has been created, NOW scrape
      ScrapeJob.perform_now(["A"])

      OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
            :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path
    }

  scenario 'Setting up for web-scraping tests' do
    # Organizations created
    expect(Organization.where(organization_id: 1, name: @first_organization_name, description: 'Unique description')).to exist
    expect(Organization.where(organization_id: 2, name: @second_organization_name, description: 'Unique description')).to exist
    expect(Organization.where(organization_id: 3, name: @third_organization_name, description: 'I do not have contact info yet! Please add it')).to exist

    # Contact_Organizations created
    expect(ContactOrganization.where(contact_organization_id: 1, contact_id: 1, organization_id: 1)).to exist
    expect(ContactOrganization.where(contact_organization_id: 2, contact_id: 2, organization_id: 2)).to exist
    
    # Contacts created
    expect(Contact.where(contact_id: 1, year: 20_210_621, name: 'Please do not overwrite me',
        email: 'john@tamu.edu', officer_position: 'President', description: 'I should still be here after scraping')).to exist
  end

  scenario 'Sunny day: Starts scraping correct output (org & contact)' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, {
        :info =>{
        :email => 'test@tamu.edu'
        }
    })
    visit admin_google_oauth2_omniauth_authorize_path
    # Checks has right entries for student organizations
    visit organizations_path
    
    expect(page).to have_content(@random_organization_name)
    expect(page).to have_content(@random_public_contact_name) 
    expect(page).to have_content(@random_public_contact_email)
  end

  scenario 'Rainy day: does not replace old contact information' do
    expect(Contact.where(contact_id: 1, year: 20_210_621, name: 'Please do not overwrite me',
        email: 'john@tamu.edu', officer_position: 'President', description: 'I should still be here after scraping')).to exist

    # New contact is created
    expect(Contact.where(name: @first_public_contact_name)).to exist
    expect(Contact.where(email: @first_public_contact_email)).to exist
  end

  scenario 'Rainy day: updates out of date organization information when both org name and contact name match' do
    expect(Contact.where(contact_id: 2, year: 20_210_621, name: @second_public_contact_name,
        email: 'outdated_email@tamu.edu', officer_position: 'President', description: 'My email should be updated')).not_to exist

    expect(Contact.where(contact_id: 2, name: @second_public_contact_name,
        email: @second_public_contact_email, officer_position: 'President')).to exist
  end

  scenario 'Rainy day: Creates new contact if organization exists and contact does not' do
    expect(Contact.where(name: @third_public_contact_name, email: @third_public_contact_email)).to exist
  end
end