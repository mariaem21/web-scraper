# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DeleteApplications', type: :system do
  
#     before do
#     driven_by(:rack_test)
#   end

  before(:all) do
    Capybara.current_driver = :selenium
  end
  after(:all) do
    Capybara.use_default_driver
  end


  it 'deletes application successfully' do
    

    visit applications_path

    click_on 'New application'
    fill_in "application[name]", with: 'Test Application'
    fill_in "application[orgID]", with: '01'
    fill_in "application[applicationID]", with: '01'
    click_on 'Create Application'

    click_on 'Destroy this application'

    accept_confirm do
        click_link 'OK'
      end
    # page.driver.browser.accept_js_confirms
    # dialog = page.driver.browser.switch_to.alert
    # dialog.accept

    expect(page).to have_content('Application was successfully destroyed.')
    
    
    
  end

  
end