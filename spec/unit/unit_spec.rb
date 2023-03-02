# frozen_string_literal: true

# location: spec/unit/unit_spec.rb
require 'rails_helper'

RSpec.describe Application, type: :model do
  it 'is not valid if applicationID already exists' do
    main_org = Organization.create(orgID: 0, name: 'Student Organization', description: 'Student organization desc')

    app01 = Application.create(applicationID: 0, orgID: 0, name: 'Test App 0', datebuilt: '02-24-2023',
                               githublink: 'github.com', description: 'test app 0_1')
    app02 = Application.create(applicationID: 0, orgID: 0, name: 'Test App 1', datebuilt: '02-24-2023',
                               githublink: 'github.com', description: 'test app 0_2')

    expect(app01).to be_valid
    expect(app02).to_not be_valid
  end

  it 'is not valid if applicationID is not valid/does not exist' do
    app2 = Application.create(applicationID: -1, orgID: 1, name: 'Test App 2', datebuilt: '02-24-2023',
                              githublink: 'github.com', description: 'test app 2')

    expect(app2).to_not be_valid
  end

  it 'is not valid if orgID is not valid/does not exist' do
    app3 = Application.create(appicationID: 2, orgID: 2, name: 'Test App 3', datebuilt: '02-24-2023',
                              githublink: 'github.com', description: 'test app 3')
    app4 = Application.create(applicationID: 4, orgID: -2, name: 'Test App 4', datebuilt: '02-24-2023',
                              githublink: 'github.com', description: 'test app 4')

    expect(app3).to_not be_valid
    expect(app4).to_not be_valid
  end
end

Rspec.describe Application, type: :model do
  it 'is not valid if name is empty' do
    app5 = Application.create(applicationID: 5, orgID: 0, name: '', datebuilt: '02-24-2023',
                              githublink: 'github.com', description: 'test app 5')

    expect(app5).to_not be_valid
  end

  it 'is not valid if githublink is empty' do
    app6 = Application.create(applicationdID: 6, orgID: 0, name: 'Test App 6', datebuilt: '02-24-2023',
                              githublink: '', description: 'test app 6')

    expect(app6).to_not be_valid
  end

  it 'is not valid if description is empty' do
    app7 = Application.create(applicationID: 7, orgID: 0, name: 'Test App 7', datebuilt: '02-24-2023',
                              githublink: 'github.com', description: '')

    expect(app7).to_not be_valid
  end
end
