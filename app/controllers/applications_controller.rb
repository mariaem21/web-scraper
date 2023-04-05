# frozen_string_literal: true

class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[show edit update destroy]


  # GET /applications or /applications.json
  def index
    @applications = Application.all

    @apps = ActiveRecord::Base.connection.execute("
      SELECT 
        applications.name AS app_name, 
        contacts.name AS contact_name,
        contacts.email,
        contacts.officer_position,
        applications.github_link,
        contacts.year,
        applications.description
      FROM contact_organizations
      INNER JOIN contacts
      ON contact_organizations.contact_id = contacts.contact_id    
      INNER JOIN applications
      ON contact_organizations.contact_organization_id = applications.contact_organization_id
      WHERE contact_organizations.organization_id = #{params[:org_id]}
    ")

    @org_id = params[:org_id]

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
    # session['filters']['org_id'] = params[:org_id]
    session['filters']['app_name'] = params[:app_name] if params[:app_name] != session['filters']['app_name'] and params[:app_name] != nil
    session['filters']['github_link'] = params[:github_link] if params[:github_link] != session['filters']['github_link'] and params[:github_link] != nil

    session['filters']['github_link'] = params[:github_link] if params[:github_link] != session['filters']['github_link'] and params[:github_link] != nil
    session['filters']['column'] = params[:column] if params[:column] != session['filters']['column'] and params[:column] != nil
    session['filters']['direction'] = params[:direction] if params[:direction] != session['filters']['direction'] and params[:direction] != nil
    
    query = "
      SELECT 
        applications.name AS app_name, 
        contacts.name AS contact_name,
        contacts.email,
        contacts.officer_position,
        applications.github_link,
        contacts.year,
        applications.description
      FROM contact_organizations
      INNER JOIN contacts
      ON contact_organizations.contact_id = contacts.contact_id    
      INNER JOIN applications
      ON contact_organizations.contact_organization_id = applications.contact_organization_id
      WHERE contact_organizations.organization_id = #{params[:org_id]}
    "
    if session['filters']['app_name']
        query += "  WHERE LOWER(applications.name) LIKE LOWER('#{session['filters']['app_name']}%')
        "
    end


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
end
