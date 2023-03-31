require "rails_helper"

RSpec.describe ContactOrganizationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/contact_organizations").to route_to("contact_organizations#index")
    end

    it "routes to #new" do
      expect(get: "/contact_organizations/new").to route_to("contact_organizations#new")
    end

    it "routes to #show" do
      expect(get: "/contact_organizations/1").to route_to("contact_organizations#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/contact_organizations/1/edit").to route_to("contact_organizations#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/contact_organizations").to route_to("contact_organizations#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/contact_organizations/1").to route_to("contact_organizations#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/contact_organizations/1").to route_to("contact_organizations#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/contact_organizations/1").to route_to("contact_organizations#destroy", id: "1")
    end
  end
end
