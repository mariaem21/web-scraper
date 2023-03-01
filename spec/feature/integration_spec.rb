# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Application page for student org', type: :feature) do

  # it 'Shows correct message when no applications exist' do
  #   visit applications_path
  #   expect(page).to(have_content('This organization does not have any applications'))
  # end

  scenario 'Shows correct application once added' do
    org = Organization.create(orgID: 1, name: 'A Battery', description: 'description')
    app1 = Application.create(applicationID: 1, orgID: 1, name: 'first application', datebuilt:20_210_621, githublink: 'github.com', description: 'test')
    visit applications_path
    expect(Application.find_by(applicationID: 1).name).to eq('first application')
    expect(Organization.find_by(orgID: 1).name).to eq('A Battery')

    visit organizations_path
    click_on "Show this organization"
    click_on "Destroy this organization"
    visit applications_path
    click_on "Show this application"
    click_on "Destroy this application"
  end

  scenario 'Shows correct contact info' do
    org = Organization.create(orgID: 1, name: 'A Battery', description: 'description')
    contact = Contact.create(personID: 1, orgID: 1, year: 20_210_621, name: 'Chad Parker',
                             email: 'cparker@corps.tamu.edu', officerposition: 'President', description: 'Unique description')
    visit contacts_path
    expect(Contact.find_by(personID: 1).name).to eq('Chad Parker')
    expect(Contact.find_by(personID: 1).email).to eq('cparker@corps.tamu.edu')

    # visit contacts_path
    # expect(page).to(have_content('Chad Parker'))
    # expect(page).to(have_content('cparker@corps.tamu.edu'))
  end

  scenario 'Shows correct number of applications' do
    org = Organization.create(orgID: 1, name: 'A Battery', description: 'description')
    app1 = Application.create(applicationID: 1, orgID: 1, name: 'first application', datebuilt:20_210_621, githublink: 'github.com', description: 'test')
    visit applications_path
    expect(page).to(have_content('1'))

    visit organizations_path
    click_on "Show this organization"
    click_on "Destroy this organization"
    visit applications_path
    click_on "Show this application"
    click_on "Destroy this application"
  end
end
