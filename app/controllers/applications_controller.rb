# frozen_string_literal: true


$org_id = 0

class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[show edit update destroy]


  # GET /applications or /applications.json
  def index
    $app_edited_rows = {}
    @applications = Application.all
    query = "
        SELECT 
        applications.name AS app_name, 
        contacts.name AS contact_name,
        contacts.email,
        contacts.officer_position,
        applications.github_link,
        contacts.year,
        applications.date_built,
        applications.description,
        categories.cat_name,
        categories.category_id,
        contact_organizations.organization_id,
        contact_organizations.contact_organization_id,
        contacts.contact_id,
        applications.application_id,
        categories.app_cat_id
        FROM contact_organizations
        INNER JOIN contacts
        ON contact_organizations.contact_id = contacts.contact_id    
        INNER JOIN applications
        ON contact_organizations.contact_organization_id = applications.contact_organization_id
        LEFT JOIN (
            SELECT
                categories.name AS cat_name,
                application_categories.application_id AS app_id,
                application_categories.application_category_id AS app_cat_id,
                categories.category_id
            FROM 
                application_categories
            INNER JOIN categories
            ON application_categories.category_id = categories.category_id
        ) AS categories
        ON categories.app_id = applications.application_id
    "

    @columns = ["Application Developed", "Contact Name", "Contact Email", "Officer Position", "Github Link", "Year Developed", "Notes", "Category"]
    @app_displayed_columns = session[:app_displayed_columns] || @columns
    @records = Organization.all
        
    if params.has_key?(:org_id) and params[:org_id] != nil
      query += "        WHERE contact_organizations.organization_id = #{params[:org_id]}"
    end
    @apps = ActiveRecord::Base.connection.execute(query)


    $org_id = params[:org_id]
    @org_id = params[:org_id]

    if @org_id
      @org_name = Organization.find(@org_id).name
    end

    respond_to do |format|
      format.xlsx  {
          response.headers[
          'Content-Disposition'
          ] = "attachment; filename=excel_file.xlsx"
      }
      
      if params[:commit] == "Exclude Selected App(s)" and params[:commit] != nil
        save_exclude_cookie(params[:applications_ids])
        format.html{ redirect_to applications_path, notice: 'Changes saved!' }
      else
        params[:applications_ids] = cookies[:applications_ids]
        format.html { render :index }
      end
    end

  end


  # GET /applications/1 or /applications/1.json
  def show; end

  def edit_row
    application_id = params[:app_id] 
    contact_id = params[:contact_id] 
    category_id = params[:category_id] 

    app_name = params[:app_name]
    github_link = params[:github_link]
    description = params[:description]

    contact_name = params[:contact_name]
    contact_email = params[:contact_email]
    officer_position = params[:officer_position]

    category_name = params[:category_name]


    puts "updating applications"


    query = "
      UPDATE applications
      SET name = '#{app_name}', github_link = '#{github_link}', description = '#{description}'
      WHERE application_id = #{application_id};
    "
    ActiveRecord::Base.connection.execute(query)

    query = "
      UPDATE contacts
      SET name = '#{contact_name}', email = '#{contact_email}', officer_position = '#{officer_position}', year = '#{Date.today}'
      WHERE contact_id = #{contact_id};
    "
    ActiveRecord::Base.connection.execute(query)

    query = "
      UPDATE categories
      SET name = '#{category_name}'
      WHERE category_id = #{category_id};
    "
    ActiveRecord::Base.connection.execute(query)

    # Return a success response
    respond_to do |format|
      format.html { redirect_to(applications_url(org_id:organization_id), notice: 'Row was edited.') }
      format.json { head :no_content }
    end
  end

  # GET /applications/new
  def new
    @application = Application.new
  end

  # GET /applications/1/edit
  def edit; end

  def list
    if params[:commit] == "Include All" and params[:commit] != nil
      save_exclude_cookie([])
    end
    
    if ($app_edited_rows)
      $app_edited_rows.each do |update_row|
        puts "Edited Rows: #{$app_edited_rows}"
        update_org_table = "UPDATE organizations SET name: '#{update_row.organization_name}' WHERE organization_id='#{update_row.organization_id}';"
        update_con_table = "UPDATE contacts SET name: '#{update_row.contact_name}', email: '#{update_row.contact_email}', officer_position: '#{update_row.officer_position}', year: '#{Date.today}' WHERE contact_id='#{update_row.contact_id}';"
        
        ActiveRecord::Base.connection.execute(update_org_table)
        ActiveRecord::Base.connection.execute(update_con_table)
      end
    end

    @columns = ["Application Developed", "Contact Name", "Contact Email", "Officer Position", "Github Link", "Year Developed", "Notes", "Category"]
    @app_displayed_columns = session[:app_displayed_columns] || @columns

    session['filters'] = {} if session['filters'].blank? # not sure how in the if-statement it knows what the session variable is since it was never made.
    
    
    session['filters']['org_id'] = params[:org_id] if params[:org_id] != session['filters']['org_id'] and params[:org_id] != nil
    session['filters']['org_id'] = $org_id if session['filters']['org_id'] == nil
    # puts "global variable #{$org_id}"
    
    if params[:app_name] != session['filters']['app_name'] and params[:app_name] != nil
      session['filters']['app_name'] = params[:app_name] 
    end
    if params[:contact_name] != session['filters']['contact_name'] and params[:contact_name] != nil
      session['filters']['contact_name'] = params[:contact_name] 
    end
    if params[:contact_email] != session['filters']['contact_email'] and params[:contact_email] != nil
      session['filters']['contact_email'] = params[:contact_email] 
    end
    if params[:officer_position] != session['filters']['officer_position'] and params[:officer_position] != nil
      session['filters']['officer_position'] = params[:officer_position] 
    end
    if params[:github_link] != session['filters']['github_link'] and params[:github_link] != nil
      session['filters']['github_link'] = params[:github_link] 
    end
    if params[:date_start] != session['filters']['date_start'] and params[:date_start] != nil
      session['filters']['date_start'] = params[:date_start] 
    end
    if params[:date_end] != session['filters']['date_end'] and params[:date_end] != nil
      session['filters']['date_end'] = params[:date_end] 
    end
    if params[:description] != session['filters']['description'] and params[:description] != nil
      session['filters']['description'] = params[:description] 
    end
    if params[:cat_name] != session['filters']['cat_name'] and params[:cat_name] != nil
      session['filters']['cat_name'] = params[:cat_name] 
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
        applications.name AS app_name, 
        contacts.name AS contact_name,
        contacts.email,
        contacts.officer_position,
        applications.github_link,
        applications.date_built,
        contacts.year,
        applications.description,
        categories.cat_name,
        contact_organizations.organization_id,
        contact_organizations.contact_organization_id,
        contacts.contact_id,
        applications.application_id,
        categories.category_id,
        categories.app_cat_id
        FROM contact_organizations
        INNER JOIN contacts
        ON contact_organizations.contact_id = contacts.contact_id    
        INNER JOIN applications
        ON contact_organizations.contact_organization_id = applications.contact_organization_id
        LEFT JOIN (
            SELECT
                categories.name AS cat_name,
                application_categories.application_id AS app_id,
                application_categories.application_category_id AS app_cat_id,
                categories.category_id
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

    if session['filters']['date_start'] and session['filters']['date_end'] and session['filters']['date_start'] != "" and session['filters']['date_end'] != ""
      query += "  AND DATE(applications.date_built) BETWEEN '#{session['filters']['date_start']}' AND '#{session['filters']['date_end']}'
      "
    elsif session['filters']['date_start'] and session['filters']['date_start'] != "" 
      query += "  AND DATE(applications.date_built) >= '#{session['filters']['date_start']}' 
      "
    elsif session['filters']['date_end'] and session['filters']['date_end'] != ""
      query += "  AND DATE(applications.date_built) <= '#{session['filters']['date_end']}' 
      "
    end
 
    puts " #{session['filters']['column']}"

    if session['filters']['column'] or session['filters']['direction'] and session['filters']['column'] != "contacts.year"
        query += "  ORDER BY LOWER(#{session['filters']['column']}) #{session['filters']['direction']}
        "
    elsif (session['filters']['column'] or session['filters']['direction']) and session['filters']['column'] == "contacts.year"
        puts "inside"
        query += "  ORDER BY DATE(#{session['filters']['column']}) #{session['filters']['direction']}
          "
    end

    $app_not_filtered_out = []
    @apps = ActiveRecord::Base.connection.execute(query)
    @apps.each do |row|
      $app_not_filtered_out.push(row['application_id'])
    end


    

    # render(partial: 'app_custom_view', locals: { apps: apps, org_id: params['org_id'] })
    @org_id=params[:org_id]
    # redirect_to action: :index, locals: {org_id: params[:org_id], apps: @apps}
    render 'index' 

  end

  def display_columns
      # session[:app_displayed_columns] = params[:columns] || @columns
      # if (@app_displayed_columns.empty?) then
      #   redirect_to action: :index, notice: 'All columns have been excluded. Please re-include columns to see data.'
      # end
      selected_columns = params[:columns] || @columns
      if selected_columns == @columns || selected_columns.blank?
        flash[:error] = "You must display at least one column."
      else
        session[:app_displayed_columns] = selected_columns
      end
      redirect_to action: :index
  end

  def delete_row 
    app_id = params[:application_id] 
    contact_id = params[:contact_id]
    contact_org_id = params[:contact_organization_id]
    application_category_id = params[:application_category_id]
    
    query = "
      DELETE FROM applications 
      WHERE applications.application_id = #{app_id}
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

    if application_category_id and application_category_id != ""
      query = "
        DELETE FROM application_categories 
        WHERE application_categories.application_category_id = #{application_category_id}
      "    
      ActiveRecord::Base.connection.execute(query)

    end

    respond_to do |format|
      format.html { redirect_to(applications_url, notice: 'Application was successfully destroyed.') }
      format.json { head(:no_content) }
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

  # Adds new table 
  def add_table_entry(organization_id: -1, app_name: "new", contact_name: "new", contact_email: "new", officer_position: "new", github_link: "new", date_built: Date.today, notes: "new", category: "new")
      organization_id = params[:organization_id]
      app_name = params[:app_name] 
      contact_name = params[:contact_name]
      contact_email = params[:contact_email]
      officer_position = params[:officer_position]
      github_link = params[:github_link]
      date_built = params[:date_built]
      notes = params[:notes]
      category = params[:category]

      if organization_id != -1 and app_name != "" and contact_name != "" and contact_email != "" and officer_position != "" and github_link != "" and date_built != "" and notes != "" and category != ""
        
        app_count = Application.count
        contact_count = Contact.count
        con_org_count = ContactOrganization.count
        cat_count = Category.count
        app_cat_count = ApplicationCategory.count
        app = {}
        contact = {}
        con_org = {}

        while Contact.where(contact_id: contact_count).exists? do
            contact_count = contact_count + 1
        end
        while ContactOrganization.where(contact_organization_id: con_org_count).exists? do
            con_org_count = con_org_count + 1
        end
        while Application.where(application_id: app_count).exists? do
            app_count = app_count + 1
        end
        while Category.where(category_id: cat_count).exists? do
            cat_count = cat_count + 1
        end
        while ApplicationCategory.where(application_category_id: app_cat_count).exists? do
            app_cat_count = app_cat_count + 1
        end

      contact = Contact.create(contact_id: contact_count, year: Date.today, name: contact_name, email: contact_email, officer_position: officer_position, description: "None", created_at:Date.today, updated_at: Date.today)
      contact_organization = ContactOrganization.create(contact_organization_id: con_org_count, contact_id: contact_count, organization_id: organization_id, created_at: Date.today, updated_at: Date.today)
      app = Application.create(application_id: app_count, contact_organization_id: con_org_count, name: app_name, date_built: date_built, github_link: github_link, description: "None", created_at: Date.today, updated_at: Date.today)
      cat = Category.create(category_id: cat_count, name: category, description: 'None', created_at: Date.today, updated_at: Date.today)
      app_cat = ApplicationCategory.create(application_category_id: app_cat_count, application_id: app_count, category_id: cat_count, created_at: Date.today, updated_at: Date.today)

        respond_to do |format|
          format.html { redirect_to applications_path(org_id:organization_id, notice: 'Application was added.') }
          format.json { head(:no_content) }
        end
        # Autofill in organization: organization_id, organization_description
        # Autofill in contact_organization: contact_organization_id, contact_id, organization_id
        # Autofill in contact: contact_id, year, description

      else
        session[:organization_id] = organization_id
        session[:app_name] = app_name
        session[:contact_name] = contact_name
        session[:contact_email] = contact_email
        session[:officer_position] = officer_position
        session[:github_link] = github_link
        session[:date_built] = date_built
        session[:notes] = notes
        session[:category] = category
        puts "second if"
        flash[:notice] = "Not all params were inputted"
        redirect_to applications_path(org_id:organization_id)
      end
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

  def save_exclude_cookie(new_params)
    if new_params == [] || new_params == nil
      cookies.permanent[:applications_ids] = []
    else
      cookies.permanent[:applications_ids] = new_params
    end
  end
end
