# frozen_string_literal: true
$org_id = 0

class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[show edit update destroy]


  # GET /applications or /applications.json
  def index
    @applications = Application.all
    query = "
        SELECT 
        applications.application_id AS app_id,
        applications.name AS app_name, 
        contacts.name AS contact_name,
        contacts.email,
        contacts.officer_position,
        applications.github_link,
        contacts.year,
        applications.description,
        categories.cat_name,
        contact_organizations.organization_id
        FROM contact_organizations
        INNER JOIN contacts
        ON contact_organizations.contact_id = contacts.contact_id    
        INNER JOIN applications
        ON contact_organizations.contact_organization_id = applications.contact_organization_id
        LEFT JOIN (
            SELECT
                categories.name AS cat_name,
                application_categories.application_id AS app_id
            FROM 
                application_categories
            INNER JOIN categories
            ON application_categories.category_id = categories.category_id

        ) AS categories
        ON categories.app_id = applications.application_id
    "
        
    if params.has_key?(:org_id) and params[:org_id] != nil
      query += "        WHERE contact_organizations.organization_id = #{params[:org_id]}"
    end
    @apps = ActiveRecord::Base.connection.execute(query)


    $org_id = params[:org_id]
    @org_id = params[:org_id]

    if params[:commit] == "Save exclude apps?"
      save_exclude_cookie_app(params[:applications_ids])
      redirect_to applications_path, notice: 'Changes saved!'
    elsif params[:commit] == "Include All"
      save_exclude_cookie_app([])
      redirect_to applications_path, notice: 'All applications have been reincluded!'
    else
      params[:applications_ids] = cookies[:applications_ids]
      render :index
    end
  end



  # GET /applications/1 or /applications/1.json
  def show; end

  # GET /applications/new
  def new
    @application = Application.new
  end

  # GET /applications/1/edit
  def edit; end

  def list 
    session['filters'] = {} if session['filters'].blank? # not sure how in the if-statement it knows what the session variable is since it was never made.
    
    
    session['filters']['org_id'] = params[:org_id] if params[:org_id] != session['filters']['org_id'] and params[:org_id] != nil
    session['filters']['org_id'] = $org_id if session['filters']['org_id'] == nil
    # puts "global variable #{$org_id}"
    
    if params[:app_name] != session['filters']['app_name'] and params[:app_name] != nil
      session['filters']['app_name'] = params[:app_name] 
    else
      session['filters']['app_name'] = ""
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
    if params[:github_link] != session['filters']['github_link'] and params[:github_link] != nil
      session['filters']['github_link'] = params[:github_link] 
    else
      session['filters']['github_link'] = ""
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
    if params[:description] != session['filters']['description'] and params[:description] != nil
      session['filters']['description'] = params[:description] 
    else
      session['filters']['description'] = ""
    end
    if params[:cat_name] != session['filters']['cat_name'] and params[:cat_name] != nil
      session['filters']['cat_name'] = params[:cat_name] 
    else
      session['filters']['cat_name'] = ""
    end
    
    
    session['filters']['column'] = params[:column] if params[:column] != session['filters']['column'] and params[:column] != nil
    session['filters']['direction'] = params[:direction] if params[:direction] != session['filters']['direction'] and params[:direction] != nil

    if session['filters']['column'] == "applications.name" or session['filters']['column'] == "contacts.name" or session['filters']['column'] == "contacts.email" or session['filters']['column'] == "contacts.officer_position" or session['filters']['column'] == "applications.github_link" or session['filters']['column'] == "contacts.year" or session['filters']['column'] == "applications.description" or session['filters']['column'] == "cat_name"
      puts "valid column name, continuing"
    else
      session['filters']['column'] = nil
      session['filters']['direction'] = nil
    end
   


    query = "
        SELECT 
        applications.application_id AS app_id,
        applications.name AS app_name, 
        contacts.name AS contact_name,
        contacts.email,
        contacts.officer_position,
        applications.github_link,
        contacts.year,
        applications.description,
        categories.cat_name
        FROM contact_organizations
        INNER JOIN contacts
        ON contact_organizations.contact_id = contacts.contact_id    
        INNER JOIN applications
        ON contact_organizations.contact_organization_id = applications.contact_organization_id
        LEFT JOIN (
            SELECT
                categories.name AS cat_name,
                application_categories.application_id AS app_id
            FROM 
                application_categories
            INNER JOIN categories
            ON application_categories.category_id = categories.category_id

        ) AS categories
        ON categories.app_id = applications.application_id
       
    "

    if params.has_key?(:org_id) and params[:org_id] != nil
      query += "         WHERE contact_organizations.organization_id = #{$org_id}"
    end
    if session['filters']['app_name'] and params.has_key?(:org_id) and params[:org_id] != nil
        query += " AND LOWER(applications.name) LIKE LOWER('#{session['filters']['app_name']}%')
        "
    else
      query += "WHERE LOWER(applications.name) LIKE LOWER('#{session['filters']['app_name']}%')
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
    if session['filters']['github_link']
      query += "  AND LOWER(applications.github_link) LIKE LOWER('#{session['filters']['github_link']}%')
      "
    end

    if session['filters']['description']
      query += "  AND LOWER(applications.description) LIKE LOWER('#{session['filters']['description']}%')
      "
    end

    if session['filters']['cat_name'] and session['filters']['cat_name'] != ""
      query += "  AND LOWER(categories.cat_name) LIKE LOWER('#{session['filters']['cat_name']}%')
      "
    end

    # if session['filters']['date_start'] and session['filters']['date_end'] and session['filters']['date_start'] != "" and session['filters']['date_end'] != ""
    #   query += "  AND DATE(contacts.year) BETWEEN '#{session['filters']['date_start']}' AND '#{session['filters']['date_end']}'
    #   "
    # elsif session['filters']['date_start'] and session['filters']['date_start'] != "" 
    #   query += "  AND DATE(contacts.year) >= '#{session['filters']['date_start']}' 
    #   "
    # elsif session['filters']['date_end'] and session['filters']['date_end'] != ""
    #   query += "  AND DATE(contacts.year) <= '#{session['filters']['date_end']}' 
    #   "
    # end

    puts " #{session['filters']['column']}"

    if session['filters']['column'] or session['filters']['direction'] and session['filters']['column'] != "contacts.year"
        query += "  ORDER BY LOWER(#{session['filters']['column']}) #{session['filters']['direction']}
        "
    elsif (session['filters']['column'] or session['filters']['direction']) and session['filters']['column'] == "contacts.year"
        puts "inside"
        query += "  ORDER BY DATE(#{session['filters']['column']}) #{session['filters']['direction']}
          "
    end


    apps = ActiveRecord::Base.connection.execute(query)

    render(partial: 'app_custom_view', locals: { apps: apps, org_id: params['org_id'] })

  end


  # POST /applications or /applications.json
  def create
    @application = Application.new(application_params)

    respond_to do |format|
      if @application.save
        format.html { redirect_to(application_url(@application), notice: 'Application was successfully created.') }
        format.json { render(:show, status: :created, location: @application) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @application.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /applications/1 or /applications/1.json
  def update
    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to(application_url(@application), notice: 'Application was successfully updated.') }
        format.json { render(:show, status: :ok, location: @application) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @application.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /applications/1 or /applications/1.json
  def destroy
    @application.destroy!

    respond_to do |format|
      format.html { redirect_to(applications_url, notice: 'Application was successfully destroyed.') }
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = Application.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def application_params
    params.require(:application).permit(:application_id, :contact_organization_id, :name, :date_built, :github_link, :description)
  end

  def save_exclude_cookie_app(new_params)
    if new_params == [] || new_params == nil
      cookies.permanent[:applications_ids] = []
    else
      cookies.permanent[:applications_ids] = new_params
    end
  end
end
