require 'rails_helper'

RSpec.describe "CancelDoesNotChangeApplicationCounts", type: :system do
  before do
    driven_by(:rack_test)
  end

  applicationsCount = Application.all.count

  it 'deletes application changes count' do
    visit '/applications'

    click_on 'delete'

    click_on 'cancel'

    newApplicationCount = Application.all.count

    applicationsCount.should eq newApplicationCount
  end

end
