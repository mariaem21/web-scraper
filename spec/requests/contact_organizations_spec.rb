require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/contact_organizations", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # ContactOrganization. As you add validations to ContactOrganization, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      ContactOrganization.create! valid_attributes
      get contact_organizations_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      contact_organization = ContactOrganization.create! valid_attributes
      get contact_organization_url(contact_organization)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_contact_organization_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      contact_organization = ContactOrganization.create! valid_attributes
      get edit_contact_organization_url(contact_organization)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new ContactOrganization" do
        expect {
          post contact_organizations_url, params: { contact_organization: valid_attributes }
        }.to change(ContactOrganization, :count).by(1)
      end

      it "redirects to the created contact_organization" do
        post contact_organizations_url, params: { contact_organization: valid_attributes }
        expect(response).to redirect_to(contact_organization_url(ContactOrganization.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new ContactOrganization" do
        expect {
          post contact_organizations_url, params: { contact_organization: invalid_attributes }
        }.to change(ContactOrganization, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post contact_organizations_url, params: { contact_organization: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested contact_organization" do
        contact_organization = ContactOrganization.create! valid_attributes
        patch contact_organization_url(contact_organization), params: { contact_organization: new_attributes }
        contact_organization.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the contact_organization" do
        contact_organization = ContactOrganization.create! valid_attributes
        patch contact_organization_url(contact_organization), params: { contact_organization: new_attributes }
        contact_organization.reload
        expect(response).to redirect_to(contact_organization_url(contact_organization))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        contact_organization = ContactOrganization.create! valid_attributes
        patch contact_organization_url(contact_organization), params: { contact_organization: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested contact_organization" do
      contact_organization = ContactOrganization.create! valid_attributes
      expect {
        delete contact_organization_url(contact_organization)
      }.to change(ContactOrganization, :count).by(-1)
    end

    it "redirects to the contact_organizations list" do
      contact_organization = ContactOrganization.create! valid_attributes
      delete contact_organization_url(contact_organization)
      expect(response).to redirect_to(contact_organizations_url)
    end
  end
end