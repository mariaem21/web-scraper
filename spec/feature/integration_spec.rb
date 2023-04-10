# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'

RSpec.describe('Navigating from organizations to applications', type: :feature) do
  scenario 'Can get to applications from home page' do
    visit organizations_path
  end
end