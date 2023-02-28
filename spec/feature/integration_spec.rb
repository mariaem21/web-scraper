# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Scraping from STUACT', type: :feature) do
  it 'correct output' do
    visit student_orgs_url
    # click_on "Scrape"
    # expect(page).to have_content('')
  end
end

RSpec.describe('Application page for student org', type: :feature) do
  it 'Shows correct message when no applications exist' do
    visit abattery_applications_path
    expect(page).to(have_content('This organization does not have any applications'))
  end

  it 'Shows correct application once added' do
    visit organizations_path
    click_on 'Scrape'
    visit organizations_abattery_path
    click_on 'New application'
    fill_in 'applicationID', with: '1'
    fill_in 'orgID', with: '1'
    fill_in 'name', with: 'Valid application'
    fill_in 'datebuilt', with: '02/24/2023'
    fill_in 'githublink', with: 'github.com'
    fill_in 'description', with: 'First application test'
    click_on 'Create application'
    visit abattery_applications_name_path
    expect(page).to(have_content('Valid application'))
  end

  it 'Shows correct organization name' do
    visit abattery_applications_path
    expect(page).to(have_content('A Battery'))
  end

  it 'Shows correct contact info' do
    visit abattery_applications_contacts_path
    expect(page).to(have_content('Chad Parker'))
    expect(page).to(have_content('cparker@corps.tamu.edu'))
  end

  it 'Shows correct number of applications' do
    visit abattery_applications_path
    expect(page).to(have_content('2'))
  end
end
