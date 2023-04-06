# By: Tripper

# frozen_string_literal: true
# location: spec/feature/feature_spec.rb
require 'rails_helper'
require 'csv'
RSpec.describe 'Downloading CSV with exclusions', type: :feature do
    scenario 'No Exclusion' do
        visit organizations_path
        click_on 'Download as CSV'
        click_on 'Download as CSV'
        workbook = RubyXL::Parser.parse("test_file.xlsx")
        worksheet = workbook[0]
        cell_value= worksheet[0][0].value
        expect(cell_value).to have_content('ID')
    end
    
    scenario 'Some Exclusion' do
        visit organizations_path
        click_on 'Download as CSV'
        
        check 'param_name1'
        click_on 'Download as CSV'
        #verify csv has all columns 
        workbook = RubyXL::Parser.parse("test_file.xlsx")
        worksheet = workbook[0]
        cell_value= worksheet[0][0].value
        expect(cell_value).not_to have_content('ID')
        expect(cell_value).to have_content('Organization Name')
    end
    
    scenario 'All Excluded' do
        visit organizations_path
        click_on 'Download as CSV'
        
        #exclude all columns
        check 'param_name1'
        check 'param_name2'
        check 'param_name3'
        check 'param_name4'
        check 'param_name5'
        check 'param_name6'
        check 'param_name7'
        click_on 'Download as CSV'
        #verify csv not downloaded
        # expect(File.exists?("test_file.csv")).to eq(false)
        #verify error message
        expect(page).to have_content('Cannot Exclude All Collumns')
    end
end