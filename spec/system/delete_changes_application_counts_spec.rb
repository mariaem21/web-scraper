require 'rails_helper'

RSpec.describe "DeleteChangesApplicationCounts", type: :system do
  before do
    driven_by(:rack_test)
  end


  it 'deletes application changes count' do
    visit "/applications"

    click_on 'New application'
    fill_in "application[name]", with: 'Test Application'
    fill_in "application[orgID]", with: '01'
    fill_in "application[applicationID]", with: '01'
    click_on 'Create Application'

    applications_count = Application.all.count

    expect(page).to have_content('Application was successfully created.')

    click_on 'Destroy this application', visible: false

    click_on 'Confirm', visible: false

    new_application_count = Application.all.count+1

    applications_count.should eq new_application_count
  end
end



          