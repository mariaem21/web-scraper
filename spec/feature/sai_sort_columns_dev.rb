# By: Maria

require 'rails_helper'

RSpec.describe 'Sort one column', type: :feature do
    scenario 'Sort student organizations' do
        visit organizations_path

        click_on 'Student Organization'
        last_name = Organization.order(name: :desc).first
        within(:xpath, "//tbody/tr[2]/td[2]") do
            page.should have_content(last_name)
        end

        click_on 'Student Organization'
        first_name = Organization.order(:name).first
        within(:xpath, "//table/tr[1]/td") do
            page.should have_content(first_name)
        end
    end

    scenario 'Sort contact names' do
        visit organizations_path
        
        click_on 'Contact Name'
        last_name = Contact.order(name: :desc).first
        within(:xpath, "//table/tr[1]/td") do
            page.should have_content(last_name)
        end

        click_on 'Contact Name'
        first_name = Contact.order(:name).first
        within(:xpath, "//table/tr[1]/td") do
            page.should have_content(first_name)
        end
    end

    scenario 'Sort contact emails' do
        visit organizations_path
        
        click_on 'Contact Email'
        last_name = Contact.order(email: :desc).first
        within(:xpath, "//table/tr[1]/td") do
            page.should have_content(last_name)
        end

        click_on 'Contact Email'
        first_name = Contact.order(:email).first
        within(:xpath, "//table/tr[1]/td") do
            page.should have_content(first_name)
        end
    end

    scenario 'Sort officer positions' do
        visit organizations_path
        
        click_on 'Officer Position'
        last_name = Contact.order(officer_position: :desc).first
        within(:xpath, "//table/tr[1]/td") do
            page.should have_content(last_name)
        end

        click_on 'Officer Position'
        first_name = Contact.order(:officer_position).first
        within(:xpath, "//table/tr[1]/td") do
            page.should have_content(first_name)
        end
    end

    scenario 'Sort last modified' do
        visit organizations_path
        
        click_on 'Last Modified'
        last_name = Contact.order(year: :desc).first
        within(:xpath, "//tbody/tr[1]/td[1]") do
            page.should have_content(last_name)
        end

        click_on 'Last Modified'
        first_name = Contact.order(:year).first
        within(:xpath, "//table/tr[1]/td") do
            page.should have_content(first_name)
        end
    end
end