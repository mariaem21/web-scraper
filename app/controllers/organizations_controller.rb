# frozen_string_literal: true

class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[show edit update destroy]
  
  # GET /organizations or /organizations.json
  def index
    $edited_rows = {}
    @orgs = ActiveRecord::Base.connection.execute("
        SELECT 
          contact_organizations.contact_organization_id,
          organizations.name AS org_name,
          organizations.organization_id,
          contacts.name AS contact_name,
          contacts.contact_id,
          contacts.email,
          contacts.officer_position,
          contacts.year,
          app_counter.app_count
        FROM contact_organizations
        RIGHT JOIN organizations
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

    @columns = ["Organization Name", "Contact Name", "Contact Email", "Officer Position", "Last Modified", "Applications"]
    @displayed_columns = session[:displayed_columns] || @columns
    @records = Organization.all

    @organizations = Organization.all

    respond_to do |format|
      format.xlsx  {
          response.headers[
          'Content-Disposition'
          ] = "attachment; filename=excel_file.xlsx"
      }
      
      if params[:commit] == "Save exclude orgs?" and params[:commit] != nil
        save_exclude_cookie(params[:organizations_ids])
        format.html{ redirect_to organizations_path, notice: 'Changes saved!' }
      elsif params[:commit] == "Include All" and params[:commit] != nil
        save_exclude_cookie([])
        format.html{ redirect_to organizations_path, notice: 'All organizations have been reincluded!'}
      else
        params[:organizations_ids] = cookies[:organizations_ids]
        format.html { render :index }
      end
    end
  end

  def display_columns
    # session[:displayed_columns] = params[:columns] || @columns
    # if (@displayed_columns.empty?) then
    #   redirect_to action: :index, notice: 'All columns have been excluded. Please re-include columns to see data.'
    # end
    selected_columns = params[:columns] || @columns
    if selected_columns == @columns || selected_columns.blank?
      flash[:error] = "You must display at least one column."
    else
      session[:displayed_columns] = selected_columns
    end
    redirect_to action: :index
end

  def scrape
    letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    ScrapeJob.perform_later(letters)
  end

  def delete
    Organization.delete_all
    Contact.delete_all
    ContactOrganization.delete_all

    save_exclude_cookie([])

    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'All organizations and contacts were successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_row
    org_id = params[:organization_id] 
    org_name = params[:organization_name]
    contact_id = params[:contact_id]
    contact_name = params[:contact_name]
    contact_email = params[:contact_email]
    officer_position = params[:officer_position]

    query = "
      UPDATE organizations
      SET name = '#{org_name}'
      WHERE organization_id = #{org_id};
    "
    ActiveRecord::Base.connection.execute(query)

    query = "
      UPDATE contacts
      SET name = '#{contact_name}', email = '#{contact_email}', officer_position = '#{officer_position}', year = '#{Date.today}'
      WHERE contact_id = #{contact_id};
    "
    ActiveRecord::Base.connection.execute(query)

    # Return a success response
    respond_to do |format|
      format.html { redirect_to(organizations_url, notice: 'Row was edited.') }
      format.json { head :no_content }
    end
  end

  def delete_row 
    org_id = params[:organization_id] 
    contact_id = params[:contact_id]
    contact_org_id = params[:contact_organization_id]
    
    query = "
      DELETE FROM organizations 
      WHERE organizations.organization_id = #{org_id}
    "
    ActiveRecord::Base.connection.execute(query)

    query = "
      DELETE FROM contact_organizations 
      WHERE contact_organizations.contact_organization_id = #{contact_org_id}
    "
    ActiveRecord::Base.connection.execute(query)

    query = "
      DELETE FROM contacts 
      WHERE contacts.contact_id = #{contact_id}
    "
    ActiveRecord::Base.connection.execute(query)

    respond_to do |format|
      format.html { redirect_to organizations_path, notice: 'Row deleted successfully.' }
    end

    # query = " SELECT 
    #     contact_organizations.contact_organization_id,
    #     organizations.name AS org_name,
    #     organizations.organization_id,
    #     contacts.name AS contact_name,
    #     contacts.contact_id,
    #     contacts.email,
    #     contacts.officer_position,
    #     contacts.year,
    #     app_counter.app_count
    #   FROM 
    #     contact_organizations
    #   INNER JOIN 
    #     organizations
    #   ON 
    #     contact_organizations.organization_id = organizations.organization_id
    #   INNER JOIN 
    #     contacts
    #   ON 
    #     contact_organizations.contact_id = contacts.contact_id    
    #   LEFT JOIN (
    #       SELECT
    #           organizations.name AS name,
    #           COUNT(applications.application_id) AS app_count
    #       FROM
    #           contact_organizations
    #       INNER JOIN 
    #           organizations
    #       ON 
    #           contact_organizations.organization_id = organizations.organization_id
    #       LEFT JOIN
    #           applications
    #       ON
    #           contact_organizations.contact_organization_id = applications.contact_organization_id
    #       GROUP BY organizations.name
    # ) AS app_counter
    #   ON organizations.name = app_counter.name
    # "
    # orgs = ActiveRecord::Base.connection.execute(query)
  end

  # GET /organizations/1 or /organizations/1.json
  def show;  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit; end

  def list

    if ($edited_rows)
      $edited_rows.each do |update_row|
        puts "Edited Rows: #{$edited_rows}"
        update_org_table = "UPDATE organizations SET name: '#{update_row.organization_name}' WHERE organization_id='#{update_row.organization_id}';"
        update_con_table = "UPDATE contacts SET name: '#{update_row.contact_name}', email: '#{update_row.contact_email}', officer_position: '#{update_row.officer_position}', year: '#{Date.today}' WHERE contact_id='#{update_row.contact_id}';"
        
        ActiveRecord::Base.connection.execute(update_org_table)
        ActiveRecord::Base.connection.execute(update_con_table)
      end
    end

    @columns = ["Organization Name", "Contact Name", "Contact Email", "Officer Position", "Last Modified", "Applications"]
    @displayed_columns = session[:displayed_columns] || @columns
    session['filters'] = {} if session['filters'].blank? # not sure how in the if-statement it knows what the session variable is since it was never made.
    # session['filters'].merge!(params)

    if params[:name] != session['filters']['name'] and params[:name] != nil
      session['filters']['name'] = params[:name] 
    else
      session['filters']['name'] = ""
    end
    if params[:contact_name] != session['filters']['contact_name'] and params[:contact_name] != nil
      session['filters']['contact_name'] = params[:contact_name] 
    else
      session['filters']['contact_name'] = ""
    end
    if params[:contact_email] != session['filters']['contact_email'] and params[:contact_email] != nil
      session['filters']['contact_email'] = params[:contact_email] 
    else
      session['filters']['contact_email'] = ""
    end
    if params[:officer_position] != session['filters']['officer_position'] and params[:officer_position] != nil
      session['filters']['officer_position'] = params[:officer_position] 
    else
      session['filters']['officer_position'] = ""
    end
    if params[:date_start] != session['filters']['date_start'] and params[:date_start] != nil
      session['filters']['date_start'] = params[:date_start] 
    else
      session['filters']['date_start'] = ""
    end
    if params[:date_end] != session['filters']['date_end'] and params[:date_end] != nil
      session['filters']['date_end'] = params[:date_end] 
    else
      session['filters']['date_end'] = ""
    end
    if params[:count_start] != session['filters']['count_start'] and params[:count_start] != nil
      session['filters']['count_start'] = params[:count_start] 
    else
      session['filters']['count_start'] = ""
    end
    if params[:count_end] != session['filters']['count_end'] and params[:count_end] != nil
      session['filters']['count_end'] = params[:count_end] 
    else
      session['filters']['count_end'] = ""
    end
    
    
    session['filters']['column'] = params[:column] if params[:column] != session['filters']['column'] and params[:column] != nil
    session['filters']['direction'] = params[:direction] if params[:direction] != session['filters']['direction'] and params[:direction] != nil
    
    query = " SELECT 
                contact_organizations.contact_organization_id,
                organizations.name AS org_name,
                organizations.organization_id,
                contacts.name AS contact_name,
                contacts.contact_id,
                contacts.email,
                contacts.officer_position,
                contacts.year,
                app_counter.app_count
              FROM 
                contact_organizations
              RIGHT JOIN 
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

    $not_filtered_out = []
    orgs = ActiveRecord::Base.connection.execute(query)
    orgs.each do |row|
      $not_filtered_out.push(row['organization_id'])
    end

    render(partial: 'custom_view', locals: { orgs: orgs })
    
  end

  def add_table_entry(org_name: "new", contact_name: "new", contact_email: "new", officer_position: "new")
      org_name = params[:org_name] 
      contact_name = params[:contact_name]
      contact_email = params[:contact_email]
      officer_position = params[:officer_position]

      org_count = 0
      contact_count = 0
      con_org_count = 0
      org = {}
      contact = {}
      con_org = {}
      while Organization.where(organization_id: org_count).exists? do
          org_count = org_count + 1
      end
      while Contact.where(contact_id: contact_count).exists? do
          contact_count = contact_count + 1
      end
      while ContactOrganization.where(contact_organization_id: con_org_count).exists? do
          con_org_count = con_org_count + 1
      end

      org = Organization.create(organization_id: org_count, name: org_name, description: "None", created_at: "#{Date.today}", updated_at: "#{Date.today}")
      contact = Contact.create(contact_id: contact_count, year: Date.today, name: contact_name, email: contact_email, officer_position: officer_position, description: "None", created_at: "#{Date.today}", updated_at: "#{Date.today}")
      contact_organization = ContactOrganization.create(contact_organization_id: con_org_count, contact_id: contact_count, organization_id: org_count, created_at: "#{Date.today}", updated_at: "#{Date.today}")
      
      respond_to do |format|
        format.html { redirect_to(organizations_url, notice: 'Organization was successfully created.') }
        format.json { head(:no_content) }
      end

      # Autofill in organization: organization_id, organization_description
      # Autofill in contact_organization: contact_organization_id, contact_id, organization_id
      # Autofill in contact: contact_id, year, description
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
    if new_params == [] || new_params == nil
      cookies.permanent[:organizations_ids] = []
    else
      cookies.permanent[:organizations_ids] = new_params
    end
  end
end
