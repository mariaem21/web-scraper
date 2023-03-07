# Table: applications
# Assigned to: Sana

# frozen_string_literal: true
# location: spec/unit/unit_spec.rb
require 'rails_helper'

RSpec.describe Application, type: :model do

    it 'is not valid if application PK is not unique' do
      org1 = Organization.create(orgID: 1, name: 'Student org A', description: 'Unique description')
      app1 = Application.create(applicationID: 1, orgID: 1, name: 'App A', datebuilt: 20_210_621,
                                githublink: 'https://gist.github.com/sseletskyy/5899820', description: 'Unique description')
      app2 = Application.create(applicationID: 1, orgID: 1, name: 'App B', datebuilt: 20_210_621,
                                githublink: 'https://gist.github.com/sseletskyy/5899821', description: 'Different here')
  
      expect(app1).to be_valid
      expect(app2).to_not be_valid
    end
  
    it 'is not valid if application ID is not valid/does not exist' do
      app1 = Application.create(applicationID: -1, orgID: 1, name: 'App 1', datebuilt: 20_210_621,
                                githublink: 'link2', description: 'description')
      expect(app1).to_not be_valid
    end

    # it 'delete application' do
    #   app = Application.find(applicationID: 1).destroy()
    #   expect(Applications.find(applicationID: 1).empty?).to be_valid
    # end
  
    it 'is not valid if orgID is not valid/does not exist' do
      app3 = Application.create(applicationID: 2, orgID: 2, name: 'Test App 3', datebuilt: 20_210_621,
                                githublink: 'github.com', description: 'test app 3')
      app4 = Application.create(applicationID: 4, orgID: -2, name: 'Test App 4', datebuilt: 20_210_621,
                                githublink: 'github.com', description: 'test app 4')
  
      expect(app3).to_not be_valid
      expect(app4).to_not be_valid
    end

    it 'is not valid if name is empty' do
      app5 = Application.create(applicationID: 5, orgID: 0, name: '', datebuilt: 20_210_621,
                                githublink: 'github.com', description: 'test app 5')
  
      expect(app5).to_not be_valid
    end
  
    it 'is not valid if githublink is empty' do
      app6 = Application.create(applicationID: 6, orgID: 0, name: 'Test App 6', datebuilt: 20_210_621,
                                githublink: '', description: 'test app 6')
  
      expect(app6).to_not be_valid
    end
  
    it 'is not valid if description is empty' do
      app7 = Application.create(applicationID: 7, orgID: 0, name: 'Test App 7', datebuilt: 20_210_621,
                                githublink: 'github.com', description: '')
  
      expect(app7).to_not be_valid
    end
end