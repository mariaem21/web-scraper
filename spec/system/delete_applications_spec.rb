require 'rails_helper'

RSpec.describe 'DeleteApplications', type: :system do
  
  before do
    driven_by(:rack_test)
  end

  it 'deletes application successfully' do

    visit "/applications"


    click_on 'New application'
    fill_in "application[name]", with: 'Test Application'
    fill_in "application[orgID]", with: '01'
    fill_in "application[applicationID]", with: '01'
    click_on 'Create Application'

    expect(page).to have_content('Application was successfully created.')

    click_on 'Destroy this application', visible: false

    click_on 'Confirm', visible: false

    expect(page).to have_content('Application was successfully destroyed.')
    
  end
end