# By: Maria 

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'
require 'csv'
Delayed::Worker.delay_jobs = false

RSpec.describe 'Downloading CSV', type: :feature do
  scenario 'Downloads a CSV' do
    data = CSV.read("new_file.csv", return_headers: true)
    row = data.shift()
    expect(row).to have_content('Student Organization')
    expect(row).to have_content('Contact Name')
    expect(row).to have_content('Contact Email')
    expect(row).to have_content('Officer Position')
    expect(row).to have_content('Last Modified')
    expect(row).to have_content('Number of Apps Built')
  end

  # Checks the first and last student orgs in the STUACT wesbite & a random middle one
  scenario '1-1 Matching: Contains (randomly selected) A Battery, Alpha Epsilon Phi Sorority, Aggie Bridge Club' do
    pass = 0
    CSV.foreach("new_file.csv") do |row|
      puts row
      if row.include? 'A Battery' 
        pass = pass + 1
      elsif row.include? 'Alpha Epsilon Phi Sorority'
        pass = pass + 1
      elsif row.include? 'Aggie Bridge Club'
        pass = pass + 1
      end
    end
    expect(pass).to equal(3)
  end
end