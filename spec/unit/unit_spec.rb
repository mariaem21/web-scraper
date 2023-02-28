RSpec.describe Application, type: :model do
  it 'is not valid if application ID is not unique' do
    app1 = Application.create(applicationID: 1, orgID: 1, name: 'App 1', datebuilt: 2023-02-21,
                              githublink: 'link1', description: 'description')
    app2 = Application.create(applicationID: 1, orgID: 2, name: 'App 2', datebuilt: 2023-02-21,
                              githublink: 'link2', description: 'different')
    expect(app1).to be_valid
    expect(app2).to_not be_valid
  end

  it 'is not valid if application ID is not valid' do
    app1 = Application.create(applicationID: -1, orgID: 1, name: 'App 1', datebuilt: 2023-02-21,
                              githublink: 'link2', description: 'description')
    expect(app1).to_not be_valid
  end

  it 'is not valid if org ID is not valid' do
    app1 = Application.create(applicationID: 1, orgID: -1, name: 'App 1', datebuilt: 2023-02-21,
                              githublink: 'link2', description: 'description')
    app2 = Application.create(applicationID: 1, orgID: 5, name: 'App 2', datebuilt: 2023-02-21,
                              githublink: 'link2', description: 'different')
    expect(app1).to_not be_valid
    expect(app2).to_not be_valid
  end
end
