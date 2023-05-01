# By: Maria

require 'rails_helper'

RSpec.describe 'Filter out 1 column & re-include column', type: :feature do
    scenario 'Filtering out student organizations' do
        visit organizations_path
        # @columns = ["Organization Name", "Contact Name", "Contact Email", "Officer Position", "Last Modified", "Applications"]
        check 'column-Organization Name'
        expect(page).to_not have_content("Student Organizations")
        check 'column-Organization Name'
        expect(page).to have_content("Student Organizations")
    end
end

#     scenario 'Filtering out contact names' do
#         visit organizations_path
#         check 'exclude_names'
#         expect(page).to_not have_content("Contact Names")
#         check 'include_names'
#         expect(page).to have_content("Contact Names")
#     end

#     scenario 'Filtering out contact emails' do
#         visit organizations_path
#         check 'exclude_emails'
#         expect(page).to_not have_content("Contact Emails")
#         check 'include_emails'
#         expect(page).to have_content("Contact Emails")
#     end

#     scenario 'Filtering out officer positions' do
#         visit organizations_path
#         check 'exclude_positions'
#         expect(page).to_not have_content("Officer Positions")
#         check 'include_positions'
#         expect(page).to have_content("Contact Positions")
#     end

#     scenario 'Filtering out last modified' do
#         visit organizations_path
#         check 'exclude_date'
#         expect(page).to_not have_content("Last Modified")
#         check 'include_date'
#         expect(page).to have_content("Last Modified")
#     end

#     scenario 'Filtering out number of apps built' do
#         visit organizations_path
#         check 'exclude_apps'
#         expect(page).to_not have_content("Number of Apps Built")
#         check 'include_apps'
#         expect(page).to have_content("Number of Apps Built")
#     end
# end

# RSpec.describe 'Filter out multiple columns & re-include column(s)', type: :feature do
#     scenario 'Filtering out student organizations & contact names' do
#         visit organizations_path
#         check 'exclude_orgs'
#         check 'exclude_names'
#         expect(page).to_not have_content("Student Organizations")
#         expect(page).to_not have_content("Contact Names")
#         check 'include_orgs'
#         expect(page).to have_content("Student Organizations")
#         expect(page).to_not have_content("Contact Names")
#         check 'include_names'
#         expect(page).to have_content("Contact Names")
#     end

#     scenario 'Filtering out emails, officer positions, apps built' do
#         visit organizations_path
#         check 'exclude_emails'
#         expect(page).to_not have_content("Contact Emails")
#         expect(page).to have_content("Officer Positions")
#         expect(page).to have_content("Last Modified")
#         check 'exclude_positions'
#         check 'exclude_date'
#         expect(page).to_not have_content("Contact Emails")
#         expect(page).to_not have_content("Officer Positions")
#         expect(page).to_not have_content("Last Modified")
#         check 'include_emails'
#         expect(page).to have_content("Contact Emails")
#         expect(page).to_not have_content("Officer Positions")
#         expect(page).to_not have_content("Last Modified")
#         check 'include_positions'
#         check 'include_date'
#     end

#     scenario 'Filtering out all columns' do
#         visit organizations_path
#         check 'exclude_orgs'
#         check 'exclude_names'
#         check 'exclude_emails'
#         check 'exclude_positions'
#         check 'exclude_date'
#         check 'exclude_apps'
#         expect(page).to have_content("All columns have been filtered out.")
#         expect(page).to_not have_content("Student Organizations")
#         expect(page).to_not have_content("Contact Names")
#         expect(page).to_not have_content("Contact Emails")
#         expect(page).to_not have_content("Officer Positions")
#         expect(page).to_not have_content("Last Modified")
#         expect(page).to_not have_content("Number of Apps Built")
#         check 'include_orgs'
#         check 'include_names'
#         check 'include_emails'
#         check 'include_positions'
#         check 'include_date'
#         check 'include_apps'
#         expect(page).to have_content("Student Organizations")
#         expect(page).to have_content("Contact Names")
#         expect(page).to have_content("Contact Emails")
#         expect(page).to have_content("Officer Positions")
#         expect(page).to have_content("Last Modified")
#         expect(page).to have_content("Number of Apps Built")
#         expect(page).to_not have_content("All columns have been filtered out.")
#     end

#     scenario 'Filter out no columns' do
#         visit organizations_path
#         expect(page).to have_content("Student Organizations")
#         expect(page).to have_content("Contact Names")
#         expect(page).to have_content("Contact Emails")
#         expect(page).to have_content("Officer Positions")
#         expect(page).to have_content("Last Modified")
#         expect(page).to have_content("Number of Apps Built")
#         expect(page).to_not have_content("All columns have been filtered out.")
#     end
# end