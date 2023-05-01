# By: Maria

require 'rails_helper'

RSpec.describe 'Filter out column(s) in organizations & re-include column(s)', type: :feature do

    scenario 'Filtering out first column: student organizations & re-include' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
            :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path
        
        # first, visit the page with the table
        visit organizations_path

        # puts page.html

        # find the checkbox element in the first row of the table
        student_org_checkbox = find(:css, 'input#column-Organization\\ Name[type="checkbox"]')
        contact_name_checkbox = find(:css, 'input#column-Contact\\ Name[type="checkbox"]')
        contact_email_checkbox = find(:css, 'input#column-Contact\\ Email[type="checkbox"]')
        officer_position_checkbox = find(:css, 'input#column-Officer\\ Position[type="checkbox"]')
        last_modified_checkbox = find(:css, 'input#column-Last\\ Modified[type="checkbox"]')
        apps_checkbox = find(:css, 'input#column-Applications[type="checkbox"]')

        # # check the checkbox
        if (student_org_checkbox.checked?)
            student_org_checkbox.uncheck
        end

        # assert that the correct checkboxes are checked
        expect(student_org_checkbox).not_to be_checked
        expect(contact_name_checkbox).to be_checked
        expect(contact_email_checkbox).to be_checked
        expect(officer_position_checkbox).to be_checked
        expect(last_modified_checkbox).to be_checked
        expect(apps_checkbox).to be_checked

        click_button "Save Excluded Columns", match: :first
        
        expect(page).not_to have_content("Student Organization")

        # Save the column headers into variables
        exclude_column = page.find('table#non-exclude-items tr:first-child th:nth-child(1)')
        first_column = page.find('table#non-exclude-items tr:first-child th:nth-child(2)')
        second_column = page.find('table#non-exclude-items tr:first-child th:nth-child(3)')
        third_column = page.find('table#non-exclude-items tr:first-child th:nth-child(4)')
        fourth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(5)')
        fifth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(6)')
        
        # Check that column headers are right values (doesn't include Student Organization)
        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Contact Name")
        expect(second_column.text).to eq("Contact Email")
        expect(third_column.text).to eq("Officer Position")
        expect(fourth_column.text).to eq("Last Modified")
        expect(fifth_column.text).to eq("Applications")
        
        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"
        # puts "SECOND COLUMN: #{second_column.text}"
        # puts "THIRD COLUMN: #{third_column.text}"
        # puts "FOURTH COLUMN: #{fourth_column.text}"
        # puts "FIFTH COLUMN: #{fifth_column.text}"

        # reinclude student organizations column
        if (!student_org_checkbox.checked?)
            student_org_checkbox.check
        end

        expect(student_org_checkbox).to be_checked

        click_button "Save Excluded Columns", match: :first

        expect(page).to have_content("Student Organization")

        # Check that column headers are right values (includes Student Organization)
        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Student Organization")
        expect(second_column.text).to eq("Contact Name")
        expect(third_column.text).to eq("Contact Email")
        expect(fourth_column.text).to eq("Officer Position")
        expect(fifth_column.text).to eq("Last Modified")

        sixth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(7)')
        expect(sixth_column.text).to eq("Applications")

        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"
        # puts "SECOND COLUMN: #{second_column.text}"
        # puts "THIRD COLUMN: #{third_column.text}"
        # puts "FOURTH COLUMN: #{fourth_column.text}"
        # puts "FIFTH COLUMN: #{fifth_column.text}"
        # puts "SIXTH COLUMN: #{sixth_column.text}"
    end

    scenario 'Filtering out contact names & re-include' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
            :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path
        
        # first, visit the page with the table
        visit organizations_path

        # puts page.html

        # find the checkbox element in the first row of the table
        student_org_checkbox = find(:css, 'input#column-Organization\\ Name[type="checkbox"]')
        contact_name_checkbox = find(:css, 'input#column-Contact\\ Name[type="checkbox"]')
        contact_email_checkbox = find(:css, 'input#column-Contact\\ Email[type="checkbox"]')
        officer_position_checkbox = find(:css, 'input#column-Officer\\ Position[type="checkbox"]')
        last_modified_checkbox = find(:css, 'input#column-Last\\ Modified[type="checkbox"]')
        apps_checkbox = find(:css, 'input#column-Applications[type="checkbox"]')

        # # check the checkbox
        if (contact_name_checkbox.checked?)
            contact_name_checkbox.uncheck
        end

        # assert that the correct checkboxes are checked
        expect(student_org_checkbox).to be_checked
        expect(contact_name_checkbox).not_to be_checked
        expect(contact_email_checkbox).to be_checked
        expect(officer_position_checkbox).to be_checked
        expect(last_modified_checkbox).to be_checked
        expect(apps_checkbox).to be_checked

        click_button "Save Excluded Columns", match: :first

        # Save the column headers into variables
        exclude_column = page.find('table#non-exclude-items tr:first-child th:nth-child(1)')
        first_column = page.find('table#non-exclude-items tr:first-child th:nth-child(2)')
        second_column = page.find('table#non-exclude-items tr:first-child th:nth-child(3)')
        third_column = page.find('table#non-exclude-items tr:first-child th:nth-child(4)')
        fourth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(5)')
        fifth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(6)')
        
        # Check that column headers are right values (doesn't include Student Organization)
        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Student Organization")
        expect(second_column.text).to eq("Contact Email")
        expect(third_column.text).to eq("Officer Position")
        expect(fourth_column.text).to eq("Last Modified")
        expect(fifth_column.text).to eq("Applications")
        
        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"
        # puts "SECOND COLUMN: #{second_column.text}"
        # puts "THIRD COLUMN: #{third_column.text}"
        # puts "FOURTH COLUMN: #{fourth_column.text}"
        # puts "FIFTH COLUMN: #{fifth_column.text}"

        # reinclude student organizations column
        if (!contact_name_checkbox.checked?)
            contact_name_checkbox.check
        end

        expect(contact_name_checkbox).to be_checked

        click_button "Save Excluded Columns", match: :first

        # Check that column headers are right values (includes Student Organization)
        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Student Organization")
        expect(second_column.text).to eq("Contact Name")
        expect(third_column.text).to eq("Contact Email")
        expect(fourth_column.text).to eq("Officer Position")
        expect(fifth_column.text).to eq("Last Modified")

        sixth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(7)')
        expect(sixth_column.text).to eq("Applications")

        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"
        # puts "SECOND COLUMN: #{second_column.text}"
        # puts "THIRD COLUMN: #{third_column.text}"
        # puts "FOURTH COLUMN: #{fourth_column.text}"
        # puts "FIFTH COLUMN: #{fifth_column.text}"
        # puts "SIXTH COLUMN: #{sixth_column.text}"
    end

    scenario 'Filtering out contact emails & re-include' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
            :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path
        
        # first, visit the page with the table
        visit organizations_path

        # puts page.html

        # find the checkbox element in the first row of the table
        student_org_checkbox = find(:css, 'input#column-Organization\\ Name[type="checkbox"]')
        contact_name_checkbox = find(:css, 'input#column-Contact\\ Name[type="checkbox"]')
        contact_email_checkbox = find(:css, 'input#column-Contact\\ Email[type="checkbox"]')
        officer_position_checkbox = find(:css, 'input#column-Officer\\ Position[type="checkbox"]')
        last_modified_checkbox = find(:css, 'input#column-Last\\ Modified[type="checkbox"]')
        apps_checkbox = find(:css, 'input#column-Applications[type="checkbox"]')

        # # check the checkbox
        if (contact_email_checkbox.checked?)
            contact_email_checkbox.uncheck
        end

        # assert that the correct checkboxes are checked
        expect(student_org_checkbox).to be_checked
        expect(contact_name_checkbox).to be_checked
        expect(contact_email_checkbox).not_to be_checked
        expect(officer_position_checkbox).to be_checked
        expect(last_modified_checkbox).to be_checked
        expect(apps_checkbox).to be_checked

        click_button "Save Excluded Columns", match: :first

        # Save the column headers into variables
        exclude_column = page.find('table#non-exclude-items tr:first-child th:nth-child(1)')
        first_column = page.find('table#non-exclude-items tr:first-child th:nth-child(2)')
        second_column = page.find('table#non-exclude-items tr:first-child th:nth-child(3)')
        third_column = page.find('table#non-exclude-items tr:first-child th:nth-child(4)')
        fourth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(5)')
        fifth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(6)')
        
        # Check that column headers are right values (doesn't include Student Organization)
        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Student Organization")
        expect(second_column.text).to eq("Contact Name")
        expect(third_column.text).to eq("Officer Position")
        expect(fourth_column.text).to eq("Last Modified")
        expect(fifth_column.text).to eq("Applications")
        
        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"
        # puts "SECOND COLUMN: #{second_column.text}"
        # puts "THIRD COLUMN: #{third_column.text}"
        # puts "FOURTH COLUMN: #{fourth_column.text}"
        # puts "FIFTH COLUMN: #{fifth_column.text}"

        # reinclude student organizations column
        if (!contact_email_checkbox.checked?)
            contact_email_checkbox.check
        end

        expect(contact_email_checkbox).to be_checked

        click_button "Save Excluded Columns", match: :first

        # Check that column headers are right values (includes Student Organization)
        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Student Organization")
        expect(second_column.text).to eq("Contact Name")
        expect(third_column.text).to eq("Contact Email")
        expect(fourth_column.text).to eq("Officer Position")
        expect(fifth_column.text).to eq("Last Modified")

        sixth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(7)')
        expect(sixth_column.text).to eq("Applications")

        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"
        # puts "SECOND COLUMN: #{second_column.text}"
        # puts "THIRD COLUMN: #{third_column.text}"
        # puts "FOURTH COLUMN: #{fourth_column.text}"
        # puts "FIFTH COLUMN: #{fifth_column.text}"
        # puts "SIXTH COLUMN: #{sixth_column.text}"
    end

    scenario 'Filtering out officer positions, last modified, # of apps built & re-include' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
            :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path
        
        # first, visit the page with the table
        visit organizations_path

        # puts page.html

        # find the checkbox element in the first row of the table
        student_org_checkbox = find(:css, 'input#column-Organization\\ Name[type="checkbox"]')
        contact_name_checkbox = find(:css, 'input#column-Contact\\ Name[type="checkbox"]')
        contact_email_checkbox = find(:css, 'input#column-Contact\\ Email[type="checkbox"]')
        officer_position_checkbox = find(:css, 'input#column-Officer\\ Position[type="checkbox"]')
        last_modified_checkbox = find(:css, 'input#column-Last\\ Modified[type="checkbox"]')
        apps_checkbox = find(:css, 'input#column-Applications[type="checkbox"]')

        # # check the checkbox
        if (officer_position_checkbox.checked?)
            officer_position_checkbox.uncheck
        end

        if (last_modified_checkbox.checked?)
            last_modified_checkbox.uncheck
        end

        if (apps_checkbox.checked?)
            apps_checkbox.uncheck
        end

        # assert that the correct checkboxes are checked
        expect(student_org_checkbox).to be_checked
        expect(contact_name_checkbox).to be_checked
        expect(contact_email_checkbox).to be_checked
        expect(officer_position_checkbox).not_to be_checked
        expect(last_modified_checkbox).not_to be_checked
        expect(apps_checkbox).not_to be_checked

        click_button "Save Excluded Columns", match: :first

        # Save the column headers into variables
        exclude_column = page.find('table#non-exclude-items tr:first-child th:nth-child(1)')
        first_column = page.find('table#non-exclude-items tr:first-child th:nth-child(2)')
        second_column = page.find('table#non-exclude-items tr:first-child th:nth-child(3)')
        third_column = page.find('table#non-exclude-items tr:first-child th:nth-child(4)')
        
        # Check that column headers are right values (doesn't include Student Organization)
        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Student Organization")
        expect(second_column.text).to eq("Contact Name")
        expect(third_column.text).to eq("Contact Email")
        
        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"
        # puts "SECOND COLUMN: #{second_column.text}"
        # puts "THIRD COLUMN: #{third_column.text}"

        # reinclude student organizations column
        if (!officer_position_checkbox.checked?)
            officer_position_checkbox.check
        end

        if (!last_modified_checkbox.checked?)
            last_modified_checkbox.check
        end

        if (!apps_checkbox.checked?)
            apps_checkbox.check
        end

        expect(officer_position_checkbox).to be_checked
        expect(last_modified_checkbox).to be_checked
        expect(apps_checkbox).to be_checked

        click_button "Save Excluded Columns", match: :first

        # Check that column headers are right values (includes Student Organization)
        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Student Organization")
        expect(second_column.text).to eq("Contact Name")
        expect(third_column.text).to eq("Contact Email")

        fourth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(5)')
        fifth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(6)')
        sixth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(7)')

        expect(fourth_column.text).to eq("Officer Position")
        expect(fifth_column.text).to eq("Last Modified")
        expect(sixth_column.text).to eq("Applications")

        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"
        # puts "SECOND COLUMN: #{second_column.text}"
        # puts "THIRD COLUMN: #{third_column.text}"
        # puts "FOURTH COLUMN: #{fourth_column.text}"
        # puts "FIFTH COLUMN: #{fifth_column.text}"
        # puts "SIXTH COLUMN: #{sixth_column.text}"
    end

    scenario 'Filtering out everything: should display message and not allow to happen' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
            :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path
        
        # first, visit the page with the table
        visit organizations_path

        # puts page.html

        # find the checkbox element in the first row of the table
        student_org_checkbox = find(:css, 'input#column-Organization\\ Name[type="checkbox"]')
        contact_name_checkbox = find(:css, 'input#column-Contact\\ Name[type="checkbox"]')
        contact_email_checkbox = find(:css, 'input#column-Contact\\ Email[type="checkbox"]')
        officer_position_checkbox = find(:css, 'input#column-Officer\\ Position[type="checkbox"]')
        last_modified_checkbox = find(:css, 'input#column-Last\\ Modified[type="checkbox"]')
        apps_checkbox = find(:css, 'input#column-Applications[type="checkbox"]')

        # check the checkbox
        if (student_org_checkbox.checked?)
            student_org_checkbox.uncheck
        end

        if (contact_name_checkbox.checked?)
            contact_name_checkbox.uncheck
        end

        if (contact_email_checkbox.checked?)
            contact_email_checkbox.uncheck
        end

        if (officer_position_checkbox.checked?)
            officer_position_checkbox.uncheck
        end

        if (last_modified_checkbox.checked?)
            last_modified_checkbox.uncheck
        end

        if (apps_checkbox.checked?)
            apps_checkbox.uncheck
        end

        # assert that the correct checkboxes are checked
        expect(student_org_checkbox).not_to be_checked
        expect(contact_name_checkbox).not_to be_checked
        expect(contact_email_checkbox).not_to be_checked
        expect(officer_position_checkbox).not_to be_checked
        expect(last_modified_checkbox).not_to be_checked
        expect(apps_checkbox).not_to be_checked

        click_button "Save Excluded Columns", match: :first

        expect(page).to have_content("You must display at least one column.")

        visit organizations_path

        # puts page.html

        # Save the column headers into variables
        exclude_column = page.find('table#non-exclude-items tr:first-child th:nth-child(1)')
        first_column = page.find('table#non-exclude-items tr:first-child th:nth-child(2)')
        second_column = page.find('table#non-exclude-items tr:first-child th:nth-child(3)')
        third_column = page.find('table#non-exclude-items tr:first-child th:nth-child(4)')
        fourth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(5)')
        fifth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(6)')
        sixth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(7)')
        
        # Check that column headers are right values (doesn't include Student Organization)
        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Student Organization")
        expect(second_column.text).to eq("Contact Name")
        expect(third_column.text).to eq("Contact Email")
        expect(fourth_column.text).to eq("Officer Position")
        expect(fifth_column.text).to eq("Last Modified")
        expect(sixth_column.text).to eq("Applications")
        
        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"
        # puts "SECOND COLUMN: #{second_column.text}"
        # puts "THIRD COLUMN: #{third_column.text}"
        # puts "FOURTH COLUMN: #{fourth_column.text}"
        # puts "FIFTH COLUMN: #{fifth_column.text}"
        # puts "SIXTH COLUMN: #{sixth_column.text}"
    end
end

RSpec.describe 'Filter out column(s) in applications & re-include column(s)', type: :feature do

    before(:all) {
        Organization.delete_all
        ContactOrganization.delete_all
        Contact.delete_all
        
        Category.delete_all
        ApplicationCategory.delete_all
        Application.delete_all

        # Create 1st organization
        Organization.create(organization_id: 1, name: "Test Organization", description: 'Unique description')
        ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
        Contact.create(contact_id: 1, year: 20_210_621, name: 'Test Name',
                email: 'test_email@tamu.edu', officer_position: 'Test Officer Position', description: 'I am creating a new application for this organization.')
        
        Application.create(application_id: 1, contact_organization_id: 1, name: "A Organization", date_built: Date.today, github_link: "https://github.com", description: "New note.")
        ApplicationCategory.create(application_category_id: 1, category_id: 1, application_id: 1)
        Category.create(category_id: 1, name: "Test category", description: "new category")

        Application.create(application_id: 2, contact_organization_id: 1, name: "B Organization", date_built: Date.today, github_link: "https://github.com", description: "New note.")
        ApplicationCategory.create(application_category_id: 2, category_id: 2, application_id: 2)
        Category.create(category_id: 2, name: "Test category", description: "new category")
    }

    scenario 'Filtering out first column: application developed & re-include' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
            :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path
        
        # first, visit the page with the table
        visit applications_path(org_id: 1)

        # puts page.html

        # find the checkbox element in the first row of the table
        app_developed_checkbox = find(:css, 'input#column-Application\\ Developed[type="checkbox"]')
        contact_name_checkbox = find(:css, 'input#column-Contact\\ Name[type="checkbox"]')
        contact_email_checkbox = find(:css, 'input#column-Contact\\ Email[type="checkbox"]')
        officer_position_checkbox = find(:css, 'input#column-Officer\\ Position[type="checkbox"]')
        github_checkbox = find(:css, 'input#column-Github\\ Link[type="checkbox"]')
        year_checkbox = find(:css, 'input#column-Year\\ Developed[type="checkbox"]')
        notes_checkbox = find(:css, 'input#column-Notes[type="checkbox"]')
        category_checkbox = find(:css, 'input#column-Category[type="checkbox"]')

        # # check the checkbox
        if (app_developed_checkbox.checked?)
            app_developed_checkbox.uncheck
        end

        # assert that the correct checkboxes are checked
        expect(app_developed_checkbox).not_to be_checked
        expect(contact_name_checkbox).to be_checked
        expect(contact_email_checkbox).to be_checked
        expect(officer_position_checkbox).to be_checked
        expect(github_checkbox).to be_checked
        expect(year_checkbox).to be_checked
        expect(notes_checkbox).to be_checked
        expect(category_checkbox).to be_checked

        click_button "Save Excluded Columns", match: :first

        # Save the column headers into variables
        exclude_column = page.find('table#non-exclude-items tr:first-child th:nth-child(1)')
        first_column = page.find('table#non-exclude-items tr:first-child th:nth-child(2)')
        second_column = page.find('table#non-exclude-items tr:first-child th:nth-child(3)')
        third_column = page.find('table#non-exclude-items tr:first-child th:nth-child(4)')
        fourth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(5)')
        fifth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(6)')
        sixth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(7)')
        seventh_column = page.find('table#non-exclude-items tr:first-child th:nth-child(8)')
        
        # Check that column headers are right values (doesn't include Application Developed)
        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Contact Name")
        expect(second_column.text).to eq("Contact Email")
        expect(third_column.text).to eq("Officer Position")
        expect(fourth_column.text).to eq("Github Link")
        expect(fifth_column.text).to eq("Year Developed")
        expect(sixth_column.text).to eq("Notes")
        expect(seventh_column.text).to eq("Category")
        
        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"
        # puts "SECOND COLUMN: #{second_column.text}"
        # puts "THIRD COLUMN: #{third_column.text}"
        # puts "FOURTH COLUMN: #{fourth_column.text}"
        # puts "FIFTH COLUMN: #{fifth_column.text}"
        # puts "SIXTH COLUMN: #{sixth_column.text}"
        # puts "SEVENTH COLUMN: #{seventh_column.text}"

        # reinclude applications column
        if (!app_developed_checkbox.checked?)
            app_developed_checkbox.check
        end

        expect(app_developed_checkbox).to be_checked

        click_button "Save Excluded Columns", match: :first

        # Check that column headers are right values (includes Student Organization)
        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Application Developed")
        expect(second_column.text).to eq("Contact Name")
        expect(third_column.text).to eq("Contact Email")
        expect(fourth_column.text).to eq("Officer Position")
        expect(fifth_column.text).to eq("Github Link")
        expect(sixth_column.text).to eq("Year Developed")
        expect(seventh_column.text).to eq("Notes")

        eighth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(9)')
        expect(eighth_column.text).to eq("Category")

        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"
        # puts "SECOND COLUMN: #{second_column.text}"
        # puts "THIRD COLUMN: #{third_column.text}"
        # puts "FOURTH COLUMN: #{fourth_column.text}"
        # puts "FIFTH COLUMN: #{fifth_column.text}"
        # puts "SIXTH COLUMN: #{sixth_column.text}"
        # puts "SEVENTH COLUMN: #{seventh_column.text}"
        # puts "EIGHTH COLUMN: #{eighth_column.text}"
    end

    scenario 'Filtering out everything BUT first column & re-include' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
            :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path
        
        # first, visit the page with the table
        visit applications_path(org_id: 1)

        # puts page.html

        # find the checkbox element in the first row of the table
        app_developed_checkbox = find(:css, 'input#column-Application\\ Developed[type="checkbox"]')
        contact_name_checkbox = find(:css, 'input#column-Contact\\ Name[type="checkbox"]')
        contact_email_checkbox = find(:css, 'input#column-Contact\\ Email[type="checkbox"]')
        officer_position_checkbox = find(:css, 'input#column-Officer\\ Position[type="checkbox"]')
        github_checkbox = find(:css, 'input#column-Github\\ Link[type="checkbox"]')
        year_checkbox = find(:css, 'input#column-Year\\ Developed[type="checkbox"]')
        notes_checkbox = find(:css, 'input#column-Notes[type="checkbox"]')
        category_checkbox = find(:css, 'input#column-Category[type="checkbox"]')

        # # check the checkbox
        if (contact_name_checkbox.checked?)
            contact_name_checkbox.uncheck
        end
        if (contact_email_checkbox.checked?)
            contact_email_checkbox.uncheck
        end
        if (officer_position_checkbox.checked?)
            officer_position_checkbox.uncheck
        end
        if (github_checkbox.checked?)
            github_checkbox.uncheck
        end
        if (year_checkbox.checked?)
            year_checkbox.uncheck
        end
        if (notes_checkbox.checked?)
            notes_checkbox.uncheck
        end
        if (category_checkbox.checked?)
            category_checkbox.uncheck
        end

        # assert that the correct checkboxes are checked
        expect(app_developed_checkbox).to be_checked
        expect(contact_name_checkbox).not_to be_checked
        expect(contact_email_checkbox).not_to be_checked
        expect(officer_position_checkbox).not_to be_checked
        expect(github_checkbox).not_to be_checked
        expect(year_checkbox).not_to be_checked
        expect(notes_checkbox).not_to be_checked
        expect(category_checkbox).not_to be_checked

        click_button "Save Excluded Columns", match: :first

        # Save the column headers into variables
        exclude_column = page.find('table#non-exclude-items tr:first-child th:nth-child(1)')
        first_column = page.find('table#non-exclude-items tr:first-child th:nth-child(2)')
        
        # Check that column headers are right values (doesn't include Application Developed)
        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Application Developed")
        
        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"

        # reinclude applications column
        if (!contact_name_checkbox.checked?)
            contact_name_checkbox.check
        end
        if (!contact_email_checkbox.checked?)
            contact_email_checkbox.check
        end
        if (!officer_position_checkbox.checked?)
            officer_position_checkbox.check
        end
        if (!github_checkbox.checked?)
            github_checkbox.check
        end
        if (!year_checkbox.checked?)
            year_checkbox.check
        end
        if (!notes_checkbox.checked?)
            notes_checkbox.check
        end
        if (!category_checkbox.checked?)
            category_checkbox.check
        end

        expect(app_developed_checkbox).to be_checked
        expect(contact_name_checkbox).to be_checked
        expect(contact_email_checkbox).to be_checked
        expect(officer_position_checkbox).to be_checked
        expect(github_checkbox).to be_checked
        expect(year_checkbox).to be_checked
        expect(notes_checkbox).to be_checked
        expect(category_checkbox).to be_checked

        click_button "Save Excluded Columns", match: :first

        # Check that column headers are right values (includes Student Organization)

        second_column = page.find('table#non-exclude-items tr:first-child th:nth-child(3)')
        third_column = page.find('table#non-exclude-items tr:first-child th:nth-child(4)')
        fourth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(5)')
        fifth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(6)')
        sixth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(7)')
        seventh_column = page.find('table#non-exclude-items tr:first-child th:nth-child(8)')
        eighth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(9)')

        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Application Developed")
        expect(second_column.text).to eq("Contact Name")
        expect(third_column.text).to eq("Contact Email")
        expect(fourth_column.text).to eq("Officer Position")
        expect(fifth_column.text).to eq("Github Link")
        expect(sixth_column.text).to eq("Year Developed")
        expect(seventh_column.text).to eq("Notes")
        expect(eighth_column.text).to eq("Category")

        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"
        # puts "SECOND COLUMN: #{second_column.text}"
        # puts "THIRD COLUMN: #{third_column.text}"
        # puts "FOURTH COLUMN: #{fourth_column.text}"
        # puts "FIFTH COLUMN: #{fifth_column.text}"
        # puts "SIXTH COLUMN: #{sixth_column.text}"
        # puts "SEVENTH COLUMN: #{seventh_column.text}"
        # puts "EIGHTH COLUMN: #{eighth_column.text}"
    end

    scenario 'Filtering out everything: should display message and not allow to happen' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
            :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path
        
        # first, visit the page with the table
        visit applications_path(org_id: 1)

        # puts page.html

        # find the checkbox element in the first row of the table
        app_developed_checkbox = find(:css, 'input#column-Application\\ Developed[type="checkbox"]')
        contact_name_checkbox = find(:css, 'input#column-Contact\\ Name[type="checkbox"]')
        contact_email_checkbox = find(:css, 'input#column-Contact\\ Email[type="checkbox"]')
        officer_position_checkbox = find(:css, 'input#column-Officer\\ Position[type="checkbox"]')
        github_checkbox = find(:css, 'input#column-Github\\ Link[type="checkbox"]')
        year_checkbox = find(:css, 'input#column-Year\\ Developed[type="checkbox"]')
        notes_checkbox = find(:css, 'input#column-Notes[type="checkbox"]')
        category_checkbox = find(:css, 'input#column-Category[type="checkbox"]')

        # # check the checkbox
        if (app_developed_checkbox.checked?)
            app_developed_checkbox.uncheck
        end
        if (contact_name_checkbox.checked?)
            contact_name_checkbox.uncheck
        end
        if (contact_email_checkbox.checked?)
            contact_email_checkbox.uncheck
        end
        if (officer_position_checkbox.checked?)
            officer_position_checkbox.uncheck
        end
        if (github_checkbox.checked?)
            github_checkbox.uncheck
        end
        if (year_checkbox.checked?)
            year_checkbox.uncheck
        end
        if (notes_checkbox.checked?)
            notes_checkbox.uncheck
        end
        if (category_checkbox.checked?)
            category_checkbox.uncheck
        end

        # assert that the correct checkboxes are checked
        expect(app_developed_checkbox).not_to be_checked
        expect(contact_name_checkbox).not_to be_checked
        expect(contact_email_checkbox).not_to be_checked
        expect(officer_position_checkbox).not_to be_checked
        expect(github_checkbox).not_to be_checked
        expect(year_checkbox).not_to be_checked
        expect(notes_checkbox).not_to be_checked
        expect(category_checkbox).not_to be_checked

        click_button "Save Excluded Columns", match: :first

        expect(page).to have_content("You must display at least one column.")

        visit applications_path(org_id: 1)

        # puts page.html

        # Save the column headers into variables
        exclude_column = page.find('table#non-exclude-items tr:first-child th:nth-child(1)')
        first_column = page.find('table#non-exclude-items tr:first-child th:nth-child(2)')
        second_column = page.find('table#non-exclude-items tr:first-child th:nth-child(3)')
        third_column = page.find('table#non-exclude-items tr:first-child th:nth-child(4)')
        fourth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(5)')
        fifth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(6)')
        sixth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(7)')
        seventh_column = page.find('table#non-exclude-items tr:first-child th:nth-child(8)')
        eighth_column = page.find('table#non-exclude-items tr:first-child th:nth-child(9)')
        
        # Check that column headers are right values (doesn't include Student Organization)
        expect(exclude_column.text).to eq("Exclude")
        expect(first_column.text).to eq("Application Developed")
        expect(second_column.text).to eq("Contact Name")
        expect(third_column.text).to eq("Contact Email")
        expect(fourth_column.text).to eq("Officer Position")
        expect(fifth_column.text).to eq("Github Link")
        expect(sixth_column.text).to eq("Year Developed")
        expect(seventh_column.text).to eq("Notes")
        expect(eighth_column.text).to eq("Category")

        # puts "EXCLUDE COLUMN: #{exclude_column.text}"
        # puts "FIRST COLUMN: #{first_column.text}"
        # puts "SECOND COLUMN: #{second_column.text}"
        # puts "THIRD COLUMN: #{third_column.text}"
        # puts "FOURTH COLUMN: #{fourth_column.text}"
        # puts "FIFTH COLUMN: #{fifth_column.text}"
        # puts "SIXTH COLUMN: #{sixth_column.text}"
        # puts "SEVENTH COLUMN: #{seventh_column.text}"
        # puts "EIGHTH COLUMN: #{eighth_column.text}"
    end
end