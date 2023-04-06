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
                  COUNT(applications.application_id) AS app_count
              FROM
                  contact_organizations
              INNER JOIN 
                  organizations
              ON 
                  contact_organizations.organization_id = organizations.organization_id
              LEFT JOIN
                  applications
              ON
                  contact_organizations.contact_organization_id = applications.contact_organization_id
              GROUP BY organizations.name
        ) AS app_counter
        ON organizations.name = app_counter.name
    ")

    puts "Column names: #{@orgs.fields.join(', ')}"

    @organizations = Organization.all
    @t1= params[:param_name1]
    @t2= params[:param_name2]
    @t3= params[:param_name3]
    @t4= params[:param_name4]
    @t5= params[:param_name5]
    @t6= params[:param_name6]
    @t7= params[:param_name7]
    respond_to do |format|
      # if params[:commit] == "Save changes?"
      #   save_exclude_cookie(params[:organization_id])
      #   flash[:confirmation] = "Changes have been saved!"
      #   format.html{ redirect_to organizations_url, notice: 'Changes saved!' }
      # else
      #   params[:organization_id] = cookies[:organization_id]
      #   format.html { render :index }
      # end

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
    letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    ScrapeJob.perform_later(letters)
  end

  def download
    DownloadJob.perform_later("Input")
  end

  def delete
    Organization.delete_all
    Contact.delete_all
    ContactOrganization.delete_all

    save_exclude_cookie("")

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
    session['filters']['contact_name'] = params[:contact_name] if params[:contact_name] != session['filters']['contact_name'] and params[:contact_name] != nil
    session['filters']['contact_email'] = params[:contact_email] if params[:contact_email] != session['filters']['contact_email'] and params[:contact_email] != nil
    session['filters']['officer_position'] = params[:officer_position] if params[:officer_position] != session['filters']['officer_position'] and params[:officer_position] != nil
    session['filters']['date_start'] = params[:date_start] if params[:date_start] != session['filters']['date_start'] and params[:date_start] != nil
    session['filters']['date_end'] = params[:date_end] if params[:date_end] != session['filters']['date_end'] and params[:date_end] != nil
    session['filters']['count_start'] = params[:count_start] if params[:count_start] != session['filters']['count_start'] and params[:count_start] != nil
    session['filters']['count_end'] = params[:count_end] if params[:count_end] != session['filters']['count_end'] and params[:count_end] != nil
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
                      COUNT(applications.application_id) AS app_count
                  FROM
                      contact_organizations
                  INNER JOIN 
                      organizations
                  ON 
                      contact_organizations.organization_id = organizations.organization_id
                  LEFT JOIN
                      applications
                  ON
                      contact_organizations.contact_organization_id = applications.contact_organization_id
                  GROUP BY organizations.name
            ) AS app_counter
              ON organizations.name = app_counter.name
            "

    if session['filters']['name']
        query += "  WHERE LOWER(organizations.name) LIKE LOWER('#{session['filters']['name']}%')
        "
    end
    if session['filters']['contact_name'] and session['filters']['contact_name']
      query += "  AND LOWER(contacts.name) LIKE LOWER('#{session['filters']['contact_name']}%')
      "
    end
    if session['filters']['contact_email']
      query += "  AND LOWER(contacts.email) LIKE LOWER('#{session['filters']['contact_email']}%')
      "
    end
    if session['filters']['officer_position']
      query += "  AND LOWER(contacts.officer_position) LIKE LOWER('#{session['filters']['officer_position']}%')
      "
    end

    if session['filters']['date_start'] and session['filters']['date_end'] and session['filters']['date_start'] != "" and session['filters']['date_end'] != ""
      query += "  AND DATE(contacts.year) BETWEEN '#{session['filters']['date_start']}' AND '#{session['filters']['date_end']}'
      "
    elsif session['filters']['date_start'] and session['filters']['date_start'] != "" 
      query += "  AND DATE(contacts.year) >= '#{session['filters']['date_start']}' 
      "
    elsif session['filters']['date_end'] and session['filters']['date_end'] != ""
      query += "  AND DATE(contacts.year) <= '#{session['filters']['date_end']}' 
      "
    end

    if session['filters']['count_start'] and session['filters']['count_end'] and session['filters']['count_start'] != "" and session['filters']['count_end'] != ""
      query += "  AND app_counter.app_count BETWEEN '#{session['filters']['count_start']}' AND '#{session['filters']['count_end']}'
      "
    elsif session['filters']['count_start'] and session['filters']['count_start'] != "" 
      query += "  AND app_counter.app_count >= '#{session['filters']['count_start']}' 
      "
    elsif session['filters']['count_end'] and session['filters']['count_end'] != ""
      query += "  AND app_counter.app_count <= '#{session['filters']['count_end']}' 
      "
    end
    if session['filters']['column'] or session['filters']['direction'] and session['filters']['column'] != "contacts.year" and session['filters']['column'] != "applications_count"
        query += "  ORDER BY LOWER(#{session['filters']['column']}) #{session['filters']['direction']}
        "
    elsif (session['filters']['column'] or session['filters']['direction']) and session['filters']['column'] == "contacts.year"
        puts "inside"
        query += "  ORDER BY DATE(#{session['filters']['column']}) #{session['filters']['direction']}
          "
    elsif (session['filters']['column'] or session['filters']['direction']) and session['filters']['column'] == "applications_count"
      query += "  ORDER BY app_counter.app_count #{session['filters']['direction']}
      "
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
    new_params = cookies[:organizations_ids]
    new_params = new_params.delete(params[:id])
    puts "HELLO"
    puts params[:id]
    puts params[:organizations_ids]
    save_exclude_cookie(new_params)
    if (@organization.organization_id != 0)
      @organization.destroy!
    end

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
    cookies.permanent[:organization_id] = new_params
  end

  def check_param(id)
    if params.has_key?(:organization_id)
      if params[:organization_id].include?(id.to_s)
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
