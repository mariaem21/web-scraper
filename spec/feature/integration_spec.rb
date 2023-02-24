# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Scraping from STUACT', type: :feature do
  scenario 'correct output' do
    visit student_orgs_url
    # click_on "Scrape"
    # expect(page).to have_content('')
  end
end

RSpec.describe 'New application requests', type: :feature do
  # Making a request with valid application information
  scenario 'Adding valid application | Should add new application to database and view section' do
    visit applications_path
    click_on 'New application'
    fill_in 'applicationID', with: '1'
    fill_in 'orgID', with: '1'
    fill_in 'name', with: 'Valid application'
    fill_in 'datebuilt', with: '02/24/2023'
    fill_in 'githublink', with: 'github.com'
    fill_in 'description', with: 'First application test'
    click_on 'Create application'
    expect(page).to have_content('Valid application')
    # expect(page).to have_content('02/24/2023')
    # expect(page).to have_content('github.com')
    # expect(page).to have_content('First application test')
  end

  # Making a request with invalid application information
  scenario 'Invalid application | Should have a popup with information warning' do
    visit applications_path
    click_on 'New application'
    fill_in 'applicationID', with: '2'
    fill_in 'orgID', with: '2'
    fill_in 'name', with: 'Invalid application'
    fill_in 'datebuilt', with: '02/24/2023'
    fill_in 'githublink', with: 'github.com'
    fill_in 'description', with: ''
    click_on 'Create application'
    expect(page).to have_content('Invalid application input')
    expect(page).to have_content('Ok')
  end
end
