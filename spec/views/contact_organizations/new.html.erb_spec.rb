require 'rails_helper'

RSpec.describe "contact_organizations/new", type: :view do
  before(:each) do
    assign(:contact_organization, ContactOrganization.new(
      contact_organization_id: 1,
      contact_id: 1,
      organization_id: 1
    ))
  end

  it "renders new contact_organization form" do
    render

    assert_select "form[action=?][method=?]", contact_organizations_path, "post" do

      assert_select "input[name=?]", "contact_organization[contact_organization_id]"

      assert_select "input[name=?]", "contact_organization[contact_id]"

      assert_select "input[name=?]", "contact_organization[organization_id]"
    end
  end
end
