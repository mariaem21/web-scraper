# By: Maria

require 'rails_helper'

RSpec.describe 'SYSTEM: Sort & filter together', type: :feature do
    scenario 'Filtering out student organizations, then sorting based on contact names' do
        visit organizations_path
        check 'exclude_orgs'
        expect(page).to_not have_content("Student Organizations")
        
        # Sort functionality
        click_on 'Contact Names'
        last_name = Contact.order(name: :desc).first
        within(:xpath, "//table/tr[1]/td") do
            page.should have_content(last_name)
        end
        
        click_on 'Contact Names'
        first_name = Contact.order(:name).first
        
        within(:xpath, "//table/tr[1]/td") do
            page.should have_content(first_name)
        end

        # Re-include student organizations
        check 'include_orgs'
        expect(page).to have_content("Student Organizations")
    end
end