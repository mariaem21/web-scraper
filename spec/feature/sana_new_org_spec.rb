# By: Sana

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

RSpec.describe('Creating entries in student org table', type: :feature) do
  scenario 'Shows correct info once added' do
    visit organizations_path
    click_on "Sign in with Google"

    visit organizations_path
    fill_in('org_name_field', with: 'Test Org')
    fill_in('contact_name_field', with: 'fake name')
    fill_in('contact_email_field', with: 'email@gmail.com')
    fill_in('officer_position_field', with: 'N/A')
    click_on 'Add New Org'
    visit organizations_path

    expect(Organization.where(name: "Test Org")).to exist
    expect(Contact.where(name: "fake name")).to exist
    expect(Contact.where(email: "email@gmail.com")).to exist
    expect(Contact.where(officer_position: "N/A")).to exist
  end
end