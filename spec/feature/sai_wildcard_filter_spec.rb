# By: Maria

require 'rails_helper'

RSpec.describe 'Wildcard filtering with search bar', type: :feature do
    scenario 'Include only student organizations with "Aggies"' do
        visit organizations_path
        fill_in 'org_name_search', :with => 'Aggies'
        # org_count = page.all(:css, 'table tr').size
        # page.all('table#myTable tr').count.should == org_count
        within(:xpath, "//table/tr").each do |row|
            row.should have_content("Aggies")
        end
        # number of times aggies appears is greater than the number of rows
    end

    scenario 'Include only contact names with "John"' do
        visit organizations_path
        fill_in 'contact_name_search', :with => 'John'
        within(:xpath, "//table/tr").each do |row|
            row.should have_content("John")
        end
    end

    scenario 'Include only contact names with "john"' do
        visit organizations_path
        fill_in 'contact_name_search', :with => 'john'
        within(:xpath, "//table/tr").each do |row|
            row.should have_content("john")
        end
    end

    scenario 'Include only contact emails with "@tamu"' do
        visit organizations_path
        fill_in 'contact_email_search', :with => '@tamu'
        within(:xpath, "//table/tr").each do |row|
            row.should have_content("@tamu")
        end
    end

    scenario 'Include only officer positions with "President"' do
        visit organizations_path
        fill_in 'officer_position_search', :with => 'President'
        within(:xpath, "//table/tr").each do |row|
            row.should have_content("President")
        end
    end

    scenario 'Include only last modified with year "2022"' do
        visit organizations_path
        fill_in 'last_modified_search', :with => '2022'
        within(:xpath, "//table/tr").each do |row|
            row.should have_content("2022")
        end
    end

    scenario 'Include only number of apps = 1' do
        visit organizations_path
        fill_in 'number_apps_search', :with => '1'
        within(:xpath, "//table/tr").each do |row|
            row.should have_content("1")
        end
    end
end