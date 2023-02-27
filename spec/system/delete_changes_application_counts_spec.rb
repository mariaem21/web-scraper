require 'rails_helper'

RSpec.describe "DeleteChangesApplicationCounts", type: :system do
  before do
    driven_by(:rack_test)
  end

  applications_count = Application.all.count

  it 'deletes application changes count' do
    visit '/applications'

    click_on 'delete'

    click_on 'confirm'

    new_application_count = Application.all.count-1

    application_count.should eq new_application_count
  end
end
