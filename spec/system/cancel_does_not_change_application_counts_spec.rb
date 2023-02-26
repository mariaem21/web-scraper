require 'rails_helper'

RSpec.describe "CancelDoesNotChangeApplicationCounts", type: :system do
  before do
    driven_by(:rack_test)
  end

  applications_count = Application.all.count

  it 'deletes application changes count' do
    visit '/applications'

    click_on 'delete'

    click_on 'cancel'

    new_application_count = Application.all.count

    application_count.should eq new_application_countend
  end

end
