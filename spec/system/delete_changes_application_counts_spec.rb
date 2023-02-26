require 'rails_helper'

RSpec.describe "DeleteChangesApplicationCounts", type: :system do
  before do
    driven_by(:rack_test)
  end

  applicationsCount = Application.all.count

  it 'deletes application changes count' do
    visit '/applications'

    click_on 'delete'

    click_on 'confirm'

    newApplicationCount = Application.all.count-1

    applicationsCount.should eq newApplicationCount
  end
end
