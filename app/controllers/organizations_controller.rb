# frozen_string_literal: true

class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[show edit update destroy]

  # GET /organizations or /organizations.json
  def index
    @organizations = Organization.all
    respond_to do |format|
      format.xlsx {
        response.headers[
          'Content-Disposition'
        ] = "attachment; filename='excel_file.xlsx'"
      }

      if params[:commit] == "Save changes?"
        save_exclude_cookie(params[:organizations_ids])
        flash[:confirmation] = "Changes have been saved!"
        format.html{ redirect_to organizations_url, notice: 'Changes saved!' }
      else
        params[:organizations_ids] = cookies[:organizations_ids]
        format.html { render :index }
      end
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

    save_exclude_cookie("")

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
    new_params = cookies[:organizations_ids]
    new_params = new_params.delete(params[:id])
    puts "HELLO"
    puts params[:id]
    puts params[:organizations_ids]
    save_exclude_cookie(new_params)

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

  def save_exclude_cookie(new_params)
    cookies.permanent[:organizations_ids] = new_params
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

  def check_for_confirmation
    if params.has_key?(:confirmation)
      return true
    else
      return false
    end
  end
end
