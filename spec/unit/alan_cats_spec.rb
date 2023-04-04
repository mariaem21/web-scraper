# Table: categories
# Assigned to: Alan

# frozen_string_literal: true
# location: spec/unit/unit_spec.rb
require 'rails_helper'

RSpec.describe Category, type: :model do
    it 'is not valid if category ID is not unique' do
        app1 = Application.create(application_id: 1, contact_organization_id: 1, name: 'App A', date_built: 20_210_621,
            github_link: 'github.com', description: 'Unique description')
        appCat1 = ApplicationCategory.create(application_category_id: 1, application_id: 1, category_id: 1)
        cat1 = Category.create(category_id: 1, name: 'Technology', description: 'Category primarily for tech based student organizations.')
        cat2 = Category.create(category_id: 1, name: 'English and Composition', description: 'Category primarily for english and writing composition based student organizations.')
        

        expect(cat1).to be_valid
        expect(cat2).to_not be_valid
    end

    it 'is not valid if category ID does not exist' do
        cat3 = Category.create(category_id: -1, name: 'Agriculture', description: 'Category primarily for agriculturual based student organizations.')

        expect(cat3).to_not be_valid
    end

    it 'is not valid if name is empty' do
        cat4 = Category.create(category_id: 4, name: '', description: 'Test category without a name.')

        expect(cat4).to_not be_valid
    end

    it 'is not valid if description is empty' do
        cat5 = Category.create(category_id: 5, name: 'Test Category', description: '')

        expect(cat5).to_not be_valid
    end

end
