# By: Maria

require 'rails_helper'

RSpec.describe 'Wildcard filtering with search bar', type: :feature do
    before(:all) {
        Organization.delete_all
        ContactOrganization.delete_all
        Contact.delete_all
        Category.delete_all
        ApplicationCategory.delete_all
        Application.delete_all

        org_A = Organization.create(organization_id: 1, name: 'A', description: 'E')
        contact_org_A = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
        contact_A = Contact.create(contact_id: 1, year: '2000-02-02', name: "B", email: "C", officer_position: "D", description: "E")

        app_A = Application.create(application_id: 1, contact_organization_id: 1, name: "K", date_built: '2000-02-02', github_link: "L", description: "M")
        cat_A = Category.create(category_id: 1, name: "N", description: "M")
        app_cat_A = ApplicationCategory.create(application_category_id: 1, application_id: 1, category_id: 1)

        app_B = Application.create(application_id: 2, contact_organization_id: 3, name: "O", date_built: '2023-02-02', github_link: "P", description: "Q")
        cat_B = Category.create(category_id: 2, name: "R", description: "Q")
        app_cat_B = ApplicationCategory.create(application_category_id: 2, application_id: 2, category_id: 2)
        contact_org_B = ContactOrganization.create(contact_organization_id: 3, contact_id: 3, organization_id: 1)
        contact_B = Contact.create(contact_id: 3, year: '2023-02-02', name: "S", email: "T", officer_position: "U", description: "V")

        org_B = Organization.create(organization_id: 2, name: 'F', description: 'J')
        contact_org_B = ContactOrganization.create(contact_organization_id: 2, contact_id: 2, organization_id: 2)
        contact_B = Contact.create(contact_id: 2, year: '2023-02-02', name: "G", email: "H", officer_position: "I", description: "J")
    }

    scenario 'Include only student organizations with "Aggies"' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
                :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path

        visit organizations_path

        row_element = page.find(:css, "tbody.text-gray-700 tr:first-child")
        row_element2 = page.find(:css, "tbody.text-gray-700 tr:nth-child(2)")

        puts row_element.text
        puts row_element2.text

        puts page.html

        # fill_in 'org_name_search', :with => 'Aggies'
        # # org_count = page.all(:css, 'table tr').size
        # # page.all('table#myTable tr').count.should == org_count
        # within(:xpath, "//tbody/tr").each do |row|
        #     row.should have_content("Aggies")
        # end
        # number of times aggies appears is greater than the number of rows
    end

    # scenario 'Include only contact names with "John"' do
    #     visit organizations_path
    #     fill_in 'contact_name_search', :with => 'John'
    #     within(:xpath, "//table/tr").each do |row|
    #         row.should have_content("John")
    #     end
    # end

    # scenario 'Include only contact names with "john"' do
    #     visit organizations_path
    #     fill_in 'contact_name_search', :with => 'john'
    #     within(:xpath, "//table/tr").each do |row|
    #         row.should have_content("john")
    #     end
    # end

    # scenario 'Include only contact emails with "@tamu"' do
    #     visit organizations_path
    #     fill_in 'contact_email_search', :with => '@tamu'
    #     within(:xpath, "//table/tr").each do |row|
    #         row.should have_content("@tamu")
    #     end
    # end

    # scenario 'Include only officer positions with "President"' do
    #     visit organizations_path
    #     fill_in 'officer_position_search', :with => 'President'
    #     within(:xpath, "//table/tr").each do |row|
    #         row.should have_content("President")
    #     end
    # end

    # scenario 'Include only last modified with year "2022"' do
    #     visit organizations_path
    #     fill_in 'last_modified_search', :with => '2022'
    #     within(:xpath, "//table/tr").each do |row|
    #         row.should have_content("2022")
    #     end
    # end

    # scenario 'Include only number of apps = 1' do
    #     visit organizations_path
    #     fill_in 'number_apps_search', :with => '1'
    #     within(:xpath, "//table/tr").each do |row|
    #         row.should have_content("1")
    #     end
    # end
end