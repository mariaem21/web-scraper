# By: Sai

require 'rails_helper'

RSpec.describe "CancelDeleteRecords", type: :feature do

  before(:all) {
    Organization.delete_all
    ContactOrganization.delete_all
    Contact.delete_all
    Application.delete_all
    Category.delete_all
    ApplicationCategory.delete_all
  }
  

  it 'click cancel on delete organization row successfully, then click confirm' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, {
      :info =>{
        :email => 'test@tamu.edu'
      }
    })
    visit admin_google_oauth2_omniauth_authorize_path

    puts "Using driver: #{Capybara.current_driver}"

    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
    contact_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
    contact = Contact.create(contact_id: 1, year: '2023-02-02', name: "RANDOM", email: "New@tamu.edu", officer_position: "None", description: "None")

    visit organizations_path
    
    row_element = page.find(:css, "tbody.text-gray-700 tr[org-id='1'][con-id='1'][con-org-id='1']")
    # puts row_element.text

    # Use row_element to find delete_button
    delete_button = row_element.find(:css, 'td:nth-child(8) a')
    puts delete_button.text

    # click the Delete button
    delete_button.click

    cancel_button = page.find(:css, 'a[href*=javascript]:contains("Cancel")', visible: false)
    cancel_button.click

    # Check that the record was not deleted
    expect(Organization.exists?(org.organization_id)).to eq(true)
    expect(ContactOrganization.exists?(contact_org.contact_organization_id)).to eq(true)
    expect(Contact.exists?(contact.contact_id)).to eq(true)

    expect(page).not_to have_content('Row deleted successfully.') 

    confirm_link = find_link('Confirm', href: '/organizations/delete_row?contact_id=1&contact_organization_id=1&organization_id=1', visible: :all)
    # puts confirm_link.text

    confirm_link.click

    # puts page.html

    # Check that the record was deleted
    expect(Organization.exists?(org.organization_id)).to eq(false)
    expect(ContactOrganization.exists?(contact_org.contact_organization_id)).to eq(false)
    expect(Contact.exists?(contact.contact_id)).to eq(false)

    expect(page).to have_content('Row deleted successfully.') 
  end

  it 'click cancel on delete application row successfully, then click confirm' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, {
      :info =>{
        :email => 'test@tamu.edu'
      }
    })
    visit admin_google_oauth2_omniauth_authorize_path

    Organization.delete_all
    ContactOrganization.delete_all
    Contact.delete_all
    Application.delete_all
    Category.delete_all
    ApplicationCategory.delete_all

    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
    contact_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
    contact = Contact.create(contact_id: 1, year: '2023-02-02', name: "RANDOM", email: "New@tamu.edu", officer_position: "None", description: "None")

    app = Application.create(application_id: 1, contact_organization_id: 1, name: "A Organization", date_built: Date.today, github_link: "https://github.com", description: "New note.")
    cat = Category.create(category_id: 1, name: "Test category", description: "new category")
    app_cat = ApplicationCategory.create(application_category_id: 1, application_id: 1, category_id: 1)

    # app2 = Application.create(application_id: 2, contact_organization_id: 1, name: "B Organization", date_built: Date.today, github_link: "https://github.com", description: "New note.")
    # app_cat_2 = ApplicationCategory.create(application_category_id: 2, category_id: 2, application_id: 2)
    # cat_2 = Category.create(category_id: 2, name: "Test category", description: "new category")

    puts "Using driver: #{Capybara.current_driver}"

    # first, visit the page with the table
    visit applications_path(org_id: 1)

    # puts page.html
    
    row_element = page.find(:css, "tbody.text-gray-700 tr:first-child")
    puts row_element.text

    # Use row_element to find delete_button
    delete_button = row_element.find(:css, 'td:nth-child(10) a')
    puts delete_button.text

    # click the Delete button
    delete_button.click

    cancel_button = page.find(:css, 'a[href*=javascript]:contains("Cancel")', visible: false)
    cancel_button.click

    # Check that the record was not deleted
    expect(Application.exists?(app.application_id)).to eq(true)
    expect(ApplicationCategory.exists?(app_cat.application_category_id)).to eq(true)
    expect(Category.exists?(cat.category_id)).to eq(true) 

    # puts page.html

    confirm_link = find_link('Confirm', href: '/applications/delete_row?application_category_id=1&application_id=1&contact_id=1&contact_organization_id=1&organization_id=1', visible: :all)
    # puts confirm_link.text

    confirm_link.click

    # puts page.html

    # Check that the record was deleted
    expect(Application.exists?(app.application_id)).to eq(false)
    expect(ApplicationCategory.exists?(app_cat.application_category_id)).to eq(false) 

  end
end