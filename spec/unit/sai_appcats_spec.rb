# Table: appcats
# Assigned to: Sai

# frozen_string_literal: true
# location: spec/unit/unit_spec.rb
require 'rails_helper'

RSpec.describe ApplicationCategory, type: :model do

    it 'is not valid if category ID is not valid' do
        org1 = Organization.create(organization_id: 1, name: 'Student org A', description: 'Unique description')
        app1 = Application.create(application_id: 1, organization_id: 1, name: 'App B', date_built: 20_210_621,
        github_link: 'https://gist.github.com/sseletskyy/5899821', description: 'Different here')
        appcat1 = ApplicationCategory.create(application_category_id: 1, application_id: 1, category_id: 1) # does not exist
        expect(appcat1).to_not be_valid
    end

    it 'is not valid if application ID is not valid' do
        cat1 = Category.create(category_id: 1, name: "Category Name",   )
        appcat1 = ApplicationCategory.create(application_category_id: 1, application_id: 1, category_id: 1) # does not exist
        expect(appcat1).to_not be_valid
    end

    it 'application_category_id is not unique' do
        org1 = Organization.create(organization_id: 1, name: 'Student org A', description: 'Unique description')
        app1 = Application.create(application_id: 1, organization_id: 1, name: 'App B', date_built: 20_210_621,
        github_link: 'https://gist.github.com/sseletskyy/5899821', description: 'Different here')
        cat1 = Category.create(category_id: 1, name: "Category Name",   )
        appcat1 = ApplicationCategory.create(application_category_id: 1, application_id: 1, category_id: 1) # does not exist
        appcat2 = ApplicationCategory.create(application_category_id: 1, application_id: 1, category_id: 1) # does not exist
        expect(appcat2).to_not be_valid
    end

    it 'is not valid if application_id is empty' do
        appcat1 = ApplicationCategory.create(application_category_id: 1, category_id: 1) # does not exist
        expect(appcat1).to_not be_valid
    end

    it 'is not valid if category_id is empty' do
        appcat1 = ApplicationCategory.create(application_category_id: 1, application_id: 1) # does not exist
        expect(appcat1).to_not be_valid
    end
end
