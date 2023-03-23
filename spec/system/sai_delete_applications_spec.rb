# By: Sai

require 'rails_helper'

RSpec.describe "CancelDeleteRecords", type: :system do
  before do
    driven_by(:rack_test)
  end


  it 'click cancel on delete application successfully' do
    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')

    visit "/applications"

    click_on 'New application'
    fill_in "application[name]", with: 'Test Application'        
    fill_in "application[contact_organization_id]", with: '01'
    fill_in "application[application_id]", with: '01'
    fill_in "application[date_built]", with: '01-01-2001'
    fill_in "application[github_link]", with: 'www.github.com'
    fill_in "application[description]", with: 'test description'      
    click_on 'Create Application'
    
    applications_count = Application.all.count

    expect(page).to have_content('Application was successfully created.')

    click_on 'Destroy this application', visible: false

    click_on 'Cancel', visible: false

    expect(page).to have_content("Cancel", count: 0)
      
  end


  
  it "cancel on delete application doesn't change count" do
    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')

    visit "/applications"

    click_on 'New application'
    fill_in "application[name]", with: 'Test Application'
    fill_in "application[contact_organization_id]", with: '01'
    fill_in "application[application_id]", with: '01'
    fill_in "application[date_built]", with: '01-01-2001'
    fill_in "application[github_link]", with: 'www.github.com'
    fill_in "application[description]", with: 'test description'      
    click_on 'Create Application'
    
    applications_count = Application.all.count

    expect(page).to have_content('Application was successfully created.')

    click_on 'Destroy this application', visible: false

    click_on 'Cancel', visible: false
    
    new_application_count = Application.all.count

    pp new_application_count

    applications_count.should eq new_application_count
  
  end

  it 'deletes application successfully' do
    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')

    visit "/applications"


    click_on 'New application'
    fill_in "application[name]", with: 'Test Application'
    fill_in "application[contact_organization_id]", with: '01'
    fill_in "application[application_id]", with: '01'
    fill_in "application[date_built]", with: '01-01-2001'
    fill_in "application[github_link]", with: 'www.github.com'
    fill_in "application[description]", with: 'test description'      
    click_on 'Create Application'

    expect(page).to have_content('Application was successfully created.')

    click_on 'Destroy this application', visible: false

    click_on 'Confirm', visible: false

    expect(page).to have_content('Application was successfully destroyed.')
    
  end

  
  it 'deletes application changes count' do
    
    org = Organization.create(organization_id: 1, name: 'A Battery', description: 'Unique description')

    visit "/applications"

    click_on 'New application'
    fill_in "application[name]", with: 'Test Application'
    fill_in "application[contact_organization_id]", with: '01'
    fill_in "application[application_id]", with: '01'
    fill_in "application[date_built]", with: '01-01-2001'
    fill_in "application[github_link]", with: 'www.github.com'
    fill_in "application[description]", with: 'test description'      
    click_on 'Create Application'

    applications_count = Application.all.count

    expect(page).to have_content('Application was successfully created.')

    click_on 'Destroy this application', visible: false

    click_on 'Confirm', visible: false

    new_application_count = Application.all.count+1

    applications_count.should eq new_application_count
  end


end