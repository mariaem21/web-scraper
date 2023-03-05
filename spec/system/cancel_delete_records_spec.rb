require 'rails_helper'

RSpec.describe "CancelDeleteRecords", type: :system do
  before do
    driven_by(:rack_test)
  end


  it 'click cancel on delete application successfully' do
    visit "/applications"

    click_on 'New application'
    fill_in "application[name]", with: 'Test Application'
    fill_in "application[orgID]", with: '01'
    fill_in "application[applicationID]", with: '01'
    click_on 'Create Application'
    
    applications_count = Application.all.count

    expect(page).to have_content('Application was successfully created.')

    click_on 'Destroy this application', visible: false

    click_on 'Cancel', visible: false

    expect(page).to have_content("Cancel", count: 0)
      
  end
end
