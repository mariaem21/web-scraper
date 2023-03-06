# Table: applications
# Assigned to: Sana

# frozen_string_literal: true
# location: spec/unit/unit_spec.rb
require 'rails_helper'

RSpec.describe Application, type: :model do

    it 'is not valid if application PK is not unique' do
      org1 = Organization.create(organization_id: 1, name: 'Student org A', description: 'Unique description')
      app1 = Application.create(application_id: 1, organization_id: 1, name: 'App A', date_built: 20_210_621,
                                github_link: 'https://gist.github.com/sseletskyy/5899820', description: 'Unique description')
      app2 = Application.create(application_id: 1, organization_id: 1, name: 'App B', date_built: 20_210_621,
                                github_link: 'https://gist.github.com/sseletskyy/5899821', description: 'Different here')
  
      expect(app1).to be_valid
      expect(app2).to_not be_valid
    end
  
    it 'is not valid if application ID is not valid/does not exist' do
      app1 = Application.create(application_id: -1, organization_id: 1, name: 'App 1', date_built: 20_210_621,
                                github_link: 'link2', description: 'description')
      expect(app1).to_not be_valid
    end

    # it 'delete application' do
    #   app = Application.find(application_id: 1).destroy()
    #   expect(Applications.find(application_id: 1).empty?).to be_valid
    # end
  
    it 'is not valid if orgID is not valid/does not exist' do
      app3 = Application.create(application_id: 2, organization_id: 2, name: 'Test App 3', date_built: 20_210_621,
                                github_link: 'github.com', description: 'test app 3')
      app4 = Application.create(application_id: 4, organization_id: -2, name: 'Test App 4', date_built: 20_210_621,
                                github_link: 'github.com', description: 'test app 4')
  
      expect(app3).to_not be_valid
      expect(app4).to_not be_valid
    end

    it 'is not valid if name is empty' do
      app5 = Application.create(application_id: 5, organization_id: 0, name: '', date_built: 20_210_621,
                                github_link: 'github.com', description: 'test app 5')
  
      expect(app5).to_not be_valid
    end
  
    it 'is not valid if githublink is empty' do
      app6 = Application.create(application_id: 6, organization_id: 0, name: 'Test App 6', date_built: 20_210_621,
                                github_link: '', description: 'test app 6')
  
      expect(app6).to_not be_valid
    end
  
    it 'is not valid if description is empty' do
      app7 = Application.create(application_id: 7, organization_id: 0, name: 'Test App 7', date_built: 20_210_621,
                                github_link: 'github.com', description: '')
  
      expect(app7).to_not be_valid
    end
end