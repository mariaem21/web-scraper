require 'rails_helper'

RSpec.describe "HorizontalFilter", type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'check data in table' do

    visit "/organizations"

    # grab the number of organizations
    org_count = Organization.count

    # check the number of rows in the table passed in from the number of active records in orgs
    page.all('table#myTable tr').count.should == org_count

    # test case will need to be modified to account for excluded organizations
    # waiting on Alan to finish up logic so we can write a test case based on exclude logic
    

  end

end
