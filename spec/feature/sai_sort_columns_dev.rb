# By: Maria

require 'rails_helper'

RSpec.describe 'Sort one column', type: :feature do
    before(:all) {
        Organization.delete_all
        ContactOrganization.delete_all
        Contact.delete_all
        Category.delete_all
        ApplicationCategory.delete_all
        Application.delete_all

        org_A = Organization.create(organization_id: 1, name: 'A', description: 'A')
        contact_org_A = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
        contact_A = Contact.create(contact_id: 1, year: '2000-02-02', name: "A", email: "A", officer_position: "A", description: "A")

        app_A = Application.create(application_id: 1, contact_organization_id: 1, name: "A", date_built: '2000-02-02', github_link: "A", description: "A")
        cat_A = Category.create(category_id: 1, name: "A", description: "A")
        app_cat_A = ApplicationCategory.create(application_category_id: 1, application_id: 1, category_id: 1)

        app_B = Application.create(application_id: 2, contact_organization_id: 3, name: "B", date_built: '2023-02-02', github_link: "B", description: "B")
        cat_B = Category.create(category_id: 2, name: "B", description: "B")
        app_cat_B = ApplicationCategory.create(application_category_id: 2, application_id: 2, category_id: 2)
        contact_org_B = ContactOrganization.create(contact_organization_id: 3, contact_id: 3, organization_id: 1)
        contact_B = Contact.create(contact_id: 3, year: '2023-02-02', name: "B", email: "B", officer_position: "B", description: "B")

        org_B = Organization.create(organization_id: 2, name: 'B', description: 'B')
        contact_org_B = ContactOrganization.create(contact_organization_id: 2, contact_id: 2, organization_id: 2)
        contact_B = Contact.create(contact_id: 2, year: '2023-02-02', name: "B", email: "B", officer_position: "B", description: "B")
    }

    scenario 'Sort organizations view' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
                :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path

        visit organizations_path

        # Click on column header to sort
        click_on 'Student Organization'

        # Get first row in table
        row_element = page.find(:css, "tbody.text-gray-700 tr:first-child")
        org_name = row_element.find(:css, 'td:nth-child(2)')
        expect(org_name.text).to eq("A")

        click_on 'Student Organization'
        expect(org_name.text).to eq("B")

        # Click on column header to sort
        click_on 'Contact Name'
        con_name = row_element.find(:css, 'td:nth-child(3)')
        expect(con_name.text).to eq("A")

        click_on 'Contact Name'
        expect(con_name.text).to eq("B")

        # Click on column header to sort
        click_on 'Contact Email'
        con_email = row_element.find(:css, 'td:nth-child(4)')
        expect(con_email.text).to eq("A")

        click_on 'Contact Email'
        expect(con_email.text).to eq("B")

        # Click on column header to sort
        click_on 'Officer Position'
        officer_pos = row_element.find(:css, 'td:nth-child(5)')
        expect(officer_pos.text).to eq("A")

        click_on 'Officer Position'
        expect(officer_pos.text).to eq("B")

        # Click on column header to sort
        click_on 'Last Modified'
        last_mod = row_element.find(:css, 'td:nth-child(6)')
        expect(last_mod.text).to eq('2000-02-02')

        click_on 'Last Modified'
        expect(last_mod.text).to eq('2023-02-02')

        # Click on column header to sort
        click_on 'Applications'
        apps = row_element.find(:css, 'td:nth-child(7)')
        expect(apps.text).to eq("0")

        click_on 'Applications'
        expect(apps.text).to eq("2")

        # puts org_name.text
        # puts con_name.text
        # puts con_email.text
        # puts officer_pos.text
        # puts last_mod.text
        # puts apps.text
    end

    scenario 'Sort applications view' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(:google_oauth2, {
            :info =>{
                :email => 'test@tamu.edu'
            }
        })
        visit admin_google_oauth2_omniauth_authorize_path

        visit applications_path(org_id: 1)

        # Click on column header to sort
        click_on 'Application Developed'

        # Get first row in table
        row_element = page.find(:css, "tbody.text-gray-700 tr:first-child")
        row_element2 = page.find(:css, "tbody.text-gray-700 tr:nth-child(2)")
        app_name = row_element.find(:css, 'td:nth-child(2)')
        expect(app_name.text).to eq("A")

        click_on 'Application Developed'
        expect(app_name.text).to eq("B")

        # Click on column header to sort
        click_on 'Contact Name'
        con_name = row_element.find(:css, 'td:nth-child(3)')
        expect(con_name.text).to eq("A")

        click_on 'Contact Name'
        expect(con_name.text).to eq("B")

        # Click on column header to sort
        click_on 'Contact Email'
        con_email = row_element.find(:css, 'td:nth-child(4)')
        expect(con_email.text).to eq("A")

        click_on 'Contact Email'
        expect(con_email.text).to eq("B")

        # Click on column header to sort
        click_on 'Officer Position'
        officer_pos = row_element.find(:css, 'td:nth-child(5)')
        expect(officer_pos.text).to eq("A")

        click_on 'Officer Position'
        expect(officer_pos.text).to eq("B")

        # Click on column header to sort
        click_on 'Github Link'
        link = row_element.find(:css, 'td:nth-child(6)')
        expect(link.text).to eq("A")

        click_on 'Github Link'
        expect(link.text).to eq("B")

        # Click on column header to sort
        click_on 'Year Developed'
        last_mod = row_element.find(:css, 'td:nth-child(7)')
        expect(last_mod.text).to eq('2000-02-02')

        click_on 'Year Developed'
        expect(last_mod.text).to eq('2023-02-02')

        # Click on column header to sort
        click_on 'Notes'
        notes = row_element.find(:css, 'td:nth-child(8)')
        expect(notes.text).to eq("A")

        click_on 'Notes'
        expect(notes.text).to eq("B")

        # Click on column header to sort
        click_on 'Category'
        cat = row_element.find(:css, 'td:nth-child(9)')
        expect(cat.text).to eq("A")

        click_on 'Category'
        expect(cat.text).to eq("B")
    end
end