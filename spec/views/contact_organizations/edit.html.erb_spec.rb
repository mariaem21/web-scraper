require 'rails_helper'

RSpec.describe "contact_organizations/edit", type: :view do
  let(:contact_organization) {
    ContactOrganization.create!(
      contact_organization_id: 1,
      contact_id: 1,
      organization_id: 1
    )
  }

  before(:each) do
    assign(:contact_organization, contact_organization)
  end

  it "renders the edit contact_organization form" do
    render

    assert_select "form[action=?][method=?]", contact_organization_path(contact_organization), "post" do

      assert_select "input[name=?]", "contact_organization[contact_organization_id]"

      assert_select "input[name=?]", "contact_organization[contact_id]"

      assert_select "input[name=?]", "contact_organization[organization_id]"
    end
  end
end
