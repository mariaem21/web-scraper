# frozen_string_literal: true

# location: spec/unit/unit_spec.rb
require 'rails_helper'


end
RSpec.describe Organization, type: :model do
  it 'is not valid if organization PK is not unique' do
    org1 = Organization.create(orgID: 1, name: 'Student org A', description: 'Unique description')
    org2 = Organization.create(orgID: 1, name: 'Student org B', description: 'Different here')
    expect(org1).to be_valid
    expect(org2).to_not be_valid
  end

  it 'is not valid if organization name is not unique' do
    org1 = Organization.create(orgID: 2, name: 'Student org A', description: 'Unique description')
    org2 = Organization.create(orgID: 3, name: 'Student org A', description: 'Different here')
    expect(org1).to be_valid
    expect(org2).to_not be_valid
  end
end

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

  it 'is not valid if orgID is not valid' do
    app1 = Application.create(applicationID: 1, orgID: -1, name: 'App A', datebuilt: 20_210_621,
                              githublink: 'https://gist.github.com/sseletskyy/5899820', description: 'Unique description')
    app2 = Application.create(applicationID: 1, orgID: 5, name: 'App B', datebuilt: 20_210_621,
                              githublink: 'https://gist.github.com/sseletskyy/5899821', description: 'Different here')
    expect(app1).to_not be_valid
    expect(app2).to_not be_valid
  end
end

RSpec.describe Contact, type: :model do
  it 'is not valid if contact PK is not unique' do
    org1 = Organization.create(orgID: 1, name: 'Student org A', description: 'Unique description')
    person1 = Contact.create(personID: 1, orgID: 1, year: 20_210_621, name: 'Person A',
                             email: 'john@tamu.edu', officerposition: 'President', description: 'Unique description')
    person2 = Contact.create(personID: 1, orgID: 1, year: 20_210_621, name: 'Person B',
                             email: 'johnsmith@tamu.edu', officerposition: 'Unknown', description: 'Different here')
    expect(person1).to be_valid
    expect(person2).to_not be_valid
  end

  it 'is not valid if orgID is not valid' do
    person1 = Contact.create(personID: 1, orgID: 1, year: 20_210_621, name: 'Person B',
                             email: 'johnsmith@tamu.edu', officerposition: 'Unknown', description: 'Different here')
    expect(person1).to_not be_valid
  end
end

### Someone else's test! ###
# RSpec.describe Application, type: :model do
#   it 'delete application' do
#     app = Application.find(applicationID: 1).destroy()
#     expect(Applications.find(applicationID: 1).empty?).to be_valid
#   end
# end
