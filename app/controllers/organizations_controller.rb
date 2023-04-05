# frozen_string_literal: true

class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[show edit update destroy]
  before_action :authenticate_admin!
  # GET /organizations or /organizations.json
  def index
    @organizations = Organization.all
    @t1= params[:param_name1]
    @t2= params[:param_name2]
    @t3= params[:param_name3]
    @t4= params[:param_name4]
    @t5= params[:param_name5]
    @t6= params[:param_name6]
    @t7= params[:param_name7]
    respond_to do |format|
      format.xlsx  {
        if params[:param_name1][:excludeOrgID]=="1" && params[:param_name2][:exclude_orgname]=="1" && params[:param_name3][:exclude_contactname]=="1" && params[:param_name4][:exclude_contactemail]=="1"  && params[:param_name5][:exclude_officer]=="1" && params[:param_name6][:exclude_date]=="1" && params[:param_name7][:exclude_appnum]=="1"
          redirect_to exclude_organizations_path, notice: 'Cannot Exclude All Collumns'
        else 
          response.headers[
          'Content-Disposition'
        ] = "attachment; filename=excel_file.xlsx"
        end
      }
      format.html { render :index }
    end
  end

  def scrape
    ScrapeJob.perform_later("https://stuactonline.tamu.edu/app/search/index/index/q/a/search/letter")
  end

  def download
    DownloadJob.perform_later("Input")
  end

  def delete
    Organization.delete_all
    Contact.delete_all
    ContactOrganization.delete_all

    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'All organizations and contacts were successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /organizations/1 or /organizations/1.json
  def show; end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit; end

  # POST /organizations or /organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.html { redirect_to(organization_url(@organization), notice: 'Organization was successfully created.') }
        format.json { render(:show, status: :created, location: @organization) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @organization.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /organizations/1 or /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to(organization_url(@organization), notice: 'Organization was successfully updated.') }
        format.json { render(:show, status: :ok, location: @organization) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @organization.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /organizations/1 or /organizations/1.json
  def destroy
    @organization.destroy!

    respond_to do |format|
      format.html { redirect_to(organizations_url, notice: 'Organization was successfully destroyed.') }
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_organization
    @organization = Organization.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def organization_params
    params.require(:organization).permit(:organization_id, :name, :description)
  end
end
