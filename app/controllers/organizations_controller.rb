# frozen_string_literal: true

class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[show edit update destroy]

  # GET /organizations or /organizations.json
  def index
    if params[:commit] == "Save changes?"
      save_exclude_cookie
    else
      params[:organizations_ids] = cookies[:organizations_ids]
    end

    puts params.inspect

    @organizations = Organization.all
    respond_to do |format|
      format.xlsx {
        response.headers[
          'Content-Disposition'
        ] = "attachment; filename='excel_file.xlsx'"
      }
      format.html { render :index }
    end
  end

  def scrape
    ScrapeJob.perform_later("https://stuactonline.tamu.edu/app/search/index/index/q/a/search/letter")
  end

  def download
    DownloadJob.perform_later("Input")
    puts params.inspect
  end

  def delete
    Organization.delete_all
    Contact.delete_all

    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'All organizations and contacts were successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /organizations/1 or /organizations/1.json
  def show;  end

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
    # params.require(:organization).permit(:organization_id, :name, :description)
    params.permit(:organization, :name, :description, :organizations_ids)
  end

  def save_exclude_cookie
    cookies.permanent[:organizations_ids] = params[:organizations_ids]
  end

  def check_param(id)
    if params.has_key?(:organizations_ids)
      if params[:organizations_ids].include?(id.to_s)
        return true
      else
        return false
      end
    else
      return false
    end
  end
  helper_method :check_param
end
