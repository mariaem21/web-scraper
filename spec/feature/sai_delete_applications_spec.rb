# By: Sai

require 'rails_helper'

RSpec.describe "CancelDeleteRecords", type: :system do
  before do
    driven_by(:rack_test)
  end
  before(:all) {Organization.delete_all}
  before(:all) {ContactOrganization.delete_all}
  before(:all) {Contact.delete_all}
  before(:all) {Application.delete_all}
  before(:all) {Category.delete_all}
  before(:all) {ApplicationCategory.delete_all}
  

  it 'click cancel on delete organization row successfully, then click confirm' do
    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
    contact_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
    contact = Contact.create(contact_id: 1, year: '2023-02-02', name: "RANDOM", email: "New@tamu.edu", officer_position: "None", description: "None")

    visit organizations_path
    row = find("tr", text: "A Battery")

    within row do
      click_button "Delete"
    end

    expect(page).to have_content('Are you sure?')
    click_on "Cancel"
    expect(Organization.exists?(org.organization_id)).to eq(true)
    expect(ContactOrganization.exists?(contact_org.contact_organization_id)).to eq(true)
    expect(Contact.exists?(contact.contact_id)).to eq(true)

    visit organizations_path
    row = find("tr", text: "New app")

    within row do
      click_button "Delete"
    end

    expect(page).to have_content('Are you sure?')
    click_on "Confirm"

    expect(page).to have_content('Organization was successfully destroyed.')
    
    # Check that the record was deleted
    expect(Organization.exists?(org.organization_id)).to eq(false)
    expect(ContactOrganization.exists?(contact_org.contact_organization_id)).to eq(false)
    expect(Contact.exists?(contact.contact_id)).to eq(false)

    expect(page).to have_content('Organization was successfully destroyed.') 
  end

  it 'click cancel on delete application row successfully, then click confirm' do
    app = Application.create(application_id: 1, contact_organization_id: 1, name: 'New app', date_built: '2023-02-02', github_link: 'new@tamu.edu', description: 'Unique description')
    contact_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
    contact = Contact.create(contact_id: 1, year: '2023-02-02', name: "RANDOM", email: "New@tamu.edu", officer_position: "None", description: "None")
    category = Category.create(category_id: 1, name: "This", description: "This")

    visit applications_path
    row = find("tr", text: "New app")

    within row do
      click_button "Delete"
    end

    expect(page).to have_content('Are you sure?')
    click_on "Cancel"
    expect(Application.exists?(app.application_id)).to eq(true)
    expect(ContactOrganization.exists?(contact_org.contact_organization_id)).to eq(true)
    expect(Contact.exists?(contact.contact_id)).to eq(true)
    expect(Category.exists?(category.category_id)).to eq(true)

    visit applications_path
    row = find("tr", text: "New app")

    within row do
      click_button "Delete"
    end

    expect(page).to have_content('Are you sure?')
    click_on "Confirm"

    expect(page).to have_content('Application was successfully destroyed.')
    
    # Check that the record was deleted
    expect(Application.exists?(app.application_id)).to eq(false)
    expect(ContactOrganization.exists?(contact_org.contact_organization_id)).to eq(false)
    expect(Contact.exists?(contact.contact_id)).to eq(false)
    expect(Category.exists?(category.category_id)).to eq(false)
  end


  
  it "cancel on delete organization doesn't change count" do
    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
    contact_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
    contact = Contact.create(contact_id: 1, year: '2023-02-02', name: "RANDOM", email: "New@tamu.edu", officer_position: "None", description: "None")
    
    # Count before delete is called
    org_count = Organization.all.count
    con_org_count = ContactOrganization.all.count
    con_count = Contact.all.count

    visit organizations_path
    row = find("tr", text: "A Battery")

    within row do
      click_button "Delete"
    end

    expect(page).to have_content('Are you sure?')
    click_on "Cancel"
    
    # Check that the record was not deleted
    expect(Organization.exists?(org.organization_id)).to eq(true)
    expect(ContactOrganization.exists?(contact_org.contact_organization_id)).to eq(true)
    expect(Contact.exists?(contact.contact_id)).to eq(true)

    new_org_count = Organization.all.count
    new_con_org_count = ContactOrganization.all.count
    new_con_count = Contact.all.count

    # Command to print to console:
    # pp new_application_count

    org_count.should eq new_org_count
    con_org_count.should eq new_con_org_count
    con_count.should eq new_con_count
  end

  
  it 'deletes organization changes count' do
    
    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')
    contact_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
    contact = Contact.create(contact_id: 1, year: '2023-02-02', name: "RANDOM", email: "New@tamu.edu", officer_position: "None", description: "None")
    
    # Count before delete is called
    org_count = Organization.all.count
    con_org_count = ContactOrganization.all.count
    con_count = Contact.all.count

    visit organizations_path
    row = find("tr", text: "A Battery")

    within row do
      click_button "Delete"
    end

    expect(page).to have_content('Are you sure?')
    click_on "Confirm"
    
    # Check that the record was not deleted
    expect(Organization.exists?(org.organization_id)).to eq(false)
    expect(ContactOrganization.exists?(contact_org.contact_organization_id)).to eq(false)
    expect(Contact.exists?(contact.contact_id)).to eq(false)

    new_org_count = Organization.all.count
    new_con_org_count = ContactOrganization.all.count
    new_con_count = Contact.all.count

    # Command to print to console:
    # pp new_application_count

    org_count.should_not eq new_org_count
    con_org_count.should_not eq new_con_org_count
    con_count.should_not eq new_con_count
  end

  it "cancel on delete application doesn't change count" do
    app = Application.create(application_id: 1, contact_organization_id: 1, name: 'New app', date_built: '2023-02-02', github_link: 'new@tamu.edu', description: 'Unique description')
    contact_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
    contact = Contact.create(contact_id: 1, year: '2023-02-02', name: "RANDOM", email: "New@tamu.edu", officer_position: "None", description: "None")
    category = Category.create(category_id: 1, name: "This", description: "This")

    # Count before delete is called
    app_count = Organization.all.count
    con_org_count = ContactOrganization.all.count
    con_count = Contact.all.count
    cat_count = Category.all.count


    visit applications_path
    row = find("tr", text: "New app")

    within row do
      click_button "Delete"
    end

    expect(page).to have_content('Are you sure?')
    click_on "Cancel"
    
    # Check that the record was deleted
    expect(Application.exists?(app.application_id)).to eq(true)
    expect(ContactOrganization.exists?(contact_org.contact_organization_id)).to eq(true)
    expect(Contact.exists?(contact.contact_id)).to eq(true)
    expect(Category.exists?(category.category_id)).to eq(true)

    new_app_count = Organization.all.count
    new_con_org_count = ContactOrganization.all.count
    new_con_count = Contact.all.count
    new_cat_count = Category.all.count

    # Command to print to console:
    # pp new_application_count

    app_count.should eq new_app_count
    con_org_count.should eq new_con_org_count
    con_count.should eq new_con_count
    cat_count.should eq new_cat_count
  end

  
  it 'deletes application changes count' do
    app = Application.create(application_id: 1, contact_organization_id: 1, name: 'New app', date_built: '2023-02-02', github_link: 'new@tamu.edu', description: 'Unique description')
    contact_org = ContactOrganization.create(contact_organization_id: 1, contact_id: 1, organization_id: 1)
    contact = Contact.create(contact_id: 1, year: '2023-02-02', name: "RANDOM", email: "New@tamu.edu", officer_position: "None", description: "None")
    category = Category.create(category_id: 1, name: "This", description: "This")

    # Count before delete is called
    app_count = Organization.all.count
    con_org_count = ContactOrganization.all.count
    con_count = Contact.all.count
    cat_count = Category.all.count


    visit applications_path
    row = find("tr", text: "New app")

    within row do
      click_button "Delete"
    end

    expect(page).to have_content('Are you sure?')
    click_on "Confirm"

    expect(page).to have_content('Application was successfully destroyed.')
    
    # Check that the record was deleted
    expect(Application.exists?(app.application_id)).to eq(false)
    expect(ContactOrganization.exists?(contact_org.contact_organization_id)).to eq(false)
    expect(Contact.exists?(contact.contact_id)).to eq(false)
    expect(Category.exists?(category.category_id)).to eq(false)

    new_app_count = Organization.all.count
    new_con_org_count = ContactOrganization.all.count
    new_con_count = Contact.all.count
    new_cat_count = Category.all.count

    # Command to print to console:
    # pp new_application_count

    app_count.should_not eq new_app_count
    con_org_count.should_not eq new_con_org_count
    con_count.should_not eq new_con_count
    cat_count.should_not eq new_cat_count
  end
end