require 'rails_helper'

# RSpec.describe "contact_organizations/index", type: :view do
#   before(:each) do
#     assign(:contact_organizations, [
#       ContactOrganization.create!(
#         contact_organization_id: 2,
#         contact_id: 3,
#         organization_id: 4
#       ),
#       ContactOrganization.create!(
#         contact_organization_id: 2,
#         contact_id: 3,
#         organization_id: 4
#       )
#     ])
#   end

#   it "renders a list of contact_organizations" do
#     render
#     cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
#     assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
#     assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
#     assert_select cell_selector, text: Regexp.new(4.to_s), count: 2
#   end
# end
