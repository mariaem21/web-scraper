# By: Sana

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

RSpec.describe('Application page for student org', type: :feature) do

  # it 'Shows correct message when no applications exist' do
  #   visit applications_path
  #   expect(page).to(have_content('This organization does not have any applications'))
  # end

  scenario 'Shows correct application once added' do
    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'description')
    app1 = Application.create(application_id: 1, contact_organization_id: 1, name: 'first application', date_built:20_210_621, github_link: 'github.com', description: 'test')
    visit applications_path
    expect(Application.find_by(application_id: 1).name).to eq('first application')
    expect(Organization.find_by(organization_id: 1).name).to eq('A Battery')

    visit organizations_path
    click_on "Show this organization"
    click_on "Destroy this organization"
    visit applications_path
    click_on "Show this application"
    click_on "Destroy this application"
  end

  scenario 'Shows correct contact info' do
    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'description')
    contact = Contact.create(contact_id: 1, year: 20_210_621, name: 'Chad Parker',
                             email: 'cparker@corps.tamu.edu', officer_position: 'President', description: 'Unique description')
    visit contacts_path
    expect(Contact.find_by(contact_id: 1).name).to eq('Chad Parker')
    expect(Contact.find_by(contact_id: 1).email).to eq('cparker@corps.tamu.edu')
  end

  # scenario 'Shows correct number of applications' do
  #   org = Organization.create(organization_id: 1, name: 'A Battery', description: 'description')
  #   app1 = Application.create(application_id: 1, name: 'first application', date_built:20_210_621, github_link: 'github.com', description: 'test')
  #   visit applications_path
  #   expect(page).to(have_content('1'))

  #   visit organizations_path
  #   click_on "Show this organization"
  #   click_on "Destroy this organization"
  #   visit applications_path
  #   click_on "Show this application"
  #   click_on "Destroy this application"
  # end
end