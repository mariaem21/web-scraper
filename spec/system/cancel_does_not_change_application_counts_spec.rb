require 'rails_helper'

RSpec.describe "CancelDoesNotChangeApplicationCounts", type: :system do
  before do
    driven_by(:rack_test)
  end


  it "cancel on delete application doesn't change count" do
    
    visit applications_path

    click_on 'New application'
    fill_in "application[name]", with: 'Test Application'
    fill_in "application[orgID]", with: '01'
    fill_in "application[applicationID]", with: '01'
    click_on 'Create Application'
    
    applications_count = Application.all.count

    expect(page).to have_content('Application was successfully created.')

    click_on 'Destroy this application', visible: false

    click_on 'Cancel', visible: false
    
    new_application_count = Application.all.count

    pp new_application_count

    applications_count.should eq new_application_count
  
  end
end