# frozen_string_literal: true

class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[show edit update destroy]

  # GET /organizations or /organizations.json
  def index

    @orgs = ActiveRecord::Base.connection.execute("
        SELECT 
          organizations.name AS org_name,
          organizations.organization_id,
          contacts.name AS contact_name,
          contacts.email,
          contacts.officer_position,
          contacts.year,
          app_counter.app_count
        FROM contact_organizations
        INNER JOIN organizations
        ON contact_organizations.organization_id = organizations.organization_id
        INNER JOIN contacts
        ON contact_organizations.contact_id = contacts.contact_id    
        LEFT JOIN (
              SELECT
                  organizations.name AS name,
                  COUNT(*) AS app_count
              FROM
                  contact_organizations
              INNER JOIN 
                  organizations
              ON 
                  contact_organizations.organization_id = organizations.organization_id
              INNER JOIN
                  applications
              ON
                  contact_organizations.contact_organization_id = applications.contact_organization_id
              GROUP BY organizations.name
        ) AS app_counter
        ON organizations.name = app_counter.name

    ")

    puts "Column names: #{@orgs.fields.join(', ')}"

    

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

  def list

       
    session['filters'] = {} if session['filters'].blank? # not sure how in the if-statement it knows what the session variable is since it was never made.
    # session['filters'].merge!(params)

    session['filters']['name'] = params[:name] if params[:name] != session['filters']['name'] and params[:name] != nil
    session['filters']['column'] = params[:column] if params[:column] != session['filters']['column'] and params[:column] != nil
    session['filters']['direction'] = params[:direction] if params[:direction] != session['filters']['direction'] and params[:direction] != nil
    
    query = " SELECT 
                organizations.name AS org_name,
                organizations.organization_id,
                contacts.name AS contact_name,
                contacts.email,
                contacts.officer_position,
                contacts.year,
                app_counter.app_count
              FROM 
                contact_organizations
              INNER JOIN 
                organizations
              ON 
                contact_organizations.organization_id = organizations.organization_id
              INNER JOIN 
                contacts
              ON 
                contact_organizations.contact_id = contacts.contact_id    
              LEFT JOIN (
                    SELECT
                        organizations.name AS name,
                        COUNT(*) AS app_count
                    FROM
                        contact_organizations
                    INNER JOIN 
                        organizations
                    ON 
                        contact_organizations.organization_id = organizations.organization_id
                    INNER JOIN
                        applications
                    ON
                        contact_organizations.contact_organization_id = applications.contact_organization_id
                    GROUP BY organizations.name
              ) AS app_counter
              ON organizations.name = app_counter.name
            "

    if session['filters']['name']
        query += "  WHERE LOWER(organizations.name) LIKE LOWER('#{session['filters']['name']}%')"
    end
    if session['filters']['column'] or session['filters']['direction']
        query += "  ORDER BY LOWER(#{session['filters']['column']}) #{session['filters']['direction']}"
    end

    orgs = ActiveRecord::Base.connection.execute(query)
    render(partial: 'custom_view', locals: { orgs: orgs })
    
  end


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
