require 'rails_helper'

RSpec.describe 'Scraping from STUACT', type: :feature do
    scenario 'correct output' do
        visit student_orgs_url
        # click_on "Scrape"
        # expect(page).to have_content('')
    end
end