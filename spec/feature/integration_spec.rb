require 'rails_helper'

RSpec.describe 'Scraping from STUACT', type: :feature do
    scenario 'correct output' do
        visit student_orgs_url
        # click_on "Scrape"
        # expect(page).to have_content('')
    end
end

RSpec.describe 'Filtering list of student orgs', type: :feature do

    scenario 'Shows correct applications after applying filter' do
        visit organizations_path 
        click_on 'Scrape' 
        visit organizations_appsbuilt_path 
        click on 'filter >1'
        expect(page).to have_content('No organizations match this fliter criteria') 
    end

    scenario 'Shows correct message when no orgs match filter criteria' do
        visit organizations_path 
        click_on 'Scrape' 
        visit organizations_appsbuilt_path 
        click on 'filter >5'
        expect(page).to have_content('No organizations match this fliter criteria') 
    end

end