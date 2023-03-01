require 'rails_helper'

RSpec.describe Application, type: :model do
  it 'is not valid if application ID is not unique' do
    org1 = Organization.create(orgID: 1, name: 'Org 1', description: 'description')
    app1 = Application.create(applicationID: 1, orgID: 1, name: 'App 1', datebuilt: 20_210_621,
                              githublink: 'link1', description: 'description')
    app2 = Application.create(applicationID: 1, orgID: 1, name: 'App 2', datebuilt: 20_210_621,
                              githublink: 'link2', description: 'different')
    expect(app1).to be_valid
    expect(app2).to_not be_valid
  end

  it 'is not valid if application ID is not valid' do
    app1 = Application.create(applicationID: -1, orgID: 1, name: 'App 1', datebuilt: 20_210_621,
                              githublink: 'link2', description: 'description')
    expect(app1).to_not be_valid
  end

  it 'is not valid if org ID is not valid' do
    app1 = Application.create(applicationID: 1, orgID: -1, name: 'App 1', datebuilt: 20_210_621,
                              githublink: 'link2', description: 'description')
    app2 = Application.create(applicationID: 1, orgID: 5, name: 'App 2', datebuilt: 20_210_621,
                              githublink: 'link2', description: 'different')
    expect(app1).to_not be_valid
    expect(app2).to_not be_valid
  end
end