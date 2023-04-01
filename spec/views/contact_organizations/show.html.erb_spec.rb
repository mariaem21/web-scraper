require 'rails_helper'

RSpec.describe "contact_organizations/show", type: :view do
  before(:each) do
    assign(:contact_organization, ContactOrganization.create!(
      contact_organization_id: 2,
      contact_id: 3,
      organization_id: 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
  end
end
