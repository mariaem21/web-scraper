# By: Maria 

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'
require 'helpers/axlsx_context'
require 'csv'
Delayed::Worker.delay_jobs = false

require 'fileutils'
require 'roo'

RSpec.describe 'Downloading CSV', type: :feature do
  include_context 'axlsx'

  scenario 'Downloads a CSV' do

    @download_columns = ["Organization Name", "Contact Name", "Contact Email", "Officer Position", "Last Modified", "Applications"]
    @download_rows = Organization.only_ids()

    wb = render_template
    sheet = wb.sheet_by_name('Organizations')
    expect(sheet).to have_cells ["Organization Name", "Contact Name", "Contact Email", "Officer Position", "Last Modified", "Applications"]

    # visit download_organizations_path(format: :xlsx)
    # wait_for_download
    # sleep 100
    
    # download_folder = File.expand_path('Users/memat/Downloads', 'C:/')
    # puts "#{download_folder}"
    # file_path = Dir.glob("#{download_folder}/*.xlsx").max_by {|f| File.mtime(f)}
    # puts "#{file_path}"
    # expect(file_path).not_to be_nil, "Expected an Excel file to be downloaded in #{download_folder}"

    # Organization.download_function()
    
    # data = CSV.read("new_file.csv", return_headers: true)
    # row = data.shift()
    # expect(row).to have_content('Student Organization')
    # expect(row).to have_content('Contact Name')
    # expect(row).to have_content('Contact Email')
    # expect(row).to have_content('Officer Position')
    # expect(row).to have_content('Last Modified')
    # expect(row).to have_content('Number of Apps Built')
  end

  # Helper method to wait for the download to complete
  def wait_for_download
    Timeout.timeout(Capybara.default_max_wait_time) do
      sleep 0.1 until downloaded?
    end
  end

  # Helper method to check if the download is complete
  def downloaded?
    download_folder = File.expand_path('~/Downloads')
    Dir.glob("#{download_folder}/*.crdownload").empty?
  end

  # # Checks the first and last student orgs in the STUACT wesbite & a random middle one
  # scenario '1-1 Matching: Contains (randomly selected) A Battery, Alpha Epsilon Phi Sorority, Aggie Bridge Club' do
  #   pass = 0
  #   CSV.foreach("new_file.csv") do |row|
  #     puts row
  #     if row.include? 'A Battery' 
  #       pass = pass + 1
  #     elsif row.include? 'Alpha Epsilon Phi Sorority'
  #       pass = pass + 1
  #     elsif row.include? 'Aggie Bridge Club'
  #       pass = pass + 1
  #     end
  #   end
  #   expect(pass).to equal(3)
  # end
end
