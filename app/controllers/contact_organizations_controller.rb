class ContactOrganizationsController < ApplicationController
  before_action :set_contact_organization, only: %i[ show edit update destroy ]

  # GET /contact_organizations or /contact_organizations.json
  def index
    @contact_organizations = ContactOrganization.all
  end

  # GET /contact_organizations/1 or /contact_organizations/1.json
  def show
  end

  # GET /contact_organizations/new
  def new
    @contact_organization = ContactOrganization.new
  end

  # GET /contact_organizations/1/edit
  def edit
  end

  # POST /contact_organizations or /contact_organizations.json
  def create
    @contact_organization = ContactOrganization.new(contact_organization_params)

    respond_to do |format|
      if @contact_organization.save
        format.html { redirect_to contact_organization_url(@contact_organization), notice: "Contact organization was successfully created." }
        format.json { render :show, status: :created, location: @contact_organization }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact_organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contact_organizations/1 or /contact_organizations/1.json
  def update
    respond_to do |format|
      if @contact_organization.update(contact_organization_params)
        format.html { redirect_to contact_organization_url(@contact_organization), notice: "Contact organization was successfully updated." }
        format.json { render :show, status: :ok, location: @contact_organization }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact_organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_organizations/1 or /contact_organizations/1.json
  def destroy
    @contact_organization.destroy

    respond_to do |format|
      format.html { redirect_to contact_organizations_url, notice: "Contact organization was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact_organization
      @contact_organization = ContactOrganization.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contact_organization_params
      params.require(:contact_organization).permit(:contact_organization_id, :contact_id, :organization_id)
    end
end
