# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

RSpec.describe('Navigating from organizations to applications', type: :feature) do
  scenario 'Can get to applications from home page' do
    visit organizations_path
  end

  it "does not allow SQL injection in queries 2" do
    malicious_input = "'; DROP TABLE organizations; --"

    # This is an example of a vulnerable query
    vulnerable_query = "SELECT * FROM organizations WHERE name = '#{malicious_input}'"

    # This is an example of a safe query within a new transaction
    safe_query = "SELECT * FROM organizations WHERE name = ?"
    safe_query_params = [malicious_input]
    Organization.transaction do
      expect(Organization.find_by_sql([safe_query, safe_query_params])).to be_empty
    end

    # Attempt the vulnerable query outside the transaction
    expect { Organization.find_by_sql(vulnerable_query) }.to raise_error(ActiveRecord::StatementInvalid)
  end
end