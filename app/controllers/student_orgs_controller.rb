class StudentOrgsController < ApplicationController
  before_action :set_student_org, only: %i[ show edit update destroy ]

  # GET /student_orgs or /student_orgs.json
  def index
    @student_orgs = StudentOrg.all
  end

  def scrape
    url = 'https://stuactonline.tamu.edu/app/search/index/index/q/a/search/letter'
    response = StudentOrgsSpider.scraping(url)
    if response[:status] == :completed && response[:error].nil?
      flash.now[:notice] = "Successfully scraped url"
    else
      flash.now[:alert] = response[:error]
    end
  rescue StandardError => e
    flash.now[:alert] = "Error: #{e}"
  end

  # GET /student_orgs/1 or /student_orgs/1.json
  def show
  end

  # GET /student_orgs/new
  def new
    @student_org = StudentOrg.new
  end

  # GET /student_orgs/1/edit
  def edit
  end

  # POST /student_orgs or /student_orgs.json
  def create
    @student_org = StudentOrg.new(student_org_params)

    respond_to do |format|
      if @student_org.save
        format.html { redirect_to student_org_url(@student_org), notice: "Student org was successfully created." }
        format.json { render :show, status: :created, location: @student_org }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student_org.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_orgs/1 or /student_orgs/1.json
  def update
    respond_to do |format|
      if @student_org.update(student_org_params)
        format.html { redirect_to student_org_url(@student_org), notice: "Student org was successfully updated." }
        format.json { render :show, status: :ok, location: @student_org }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student_org.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_orgs/1 or /student_orgs/1.json
  def destroy
    @student_org.destroy

    respond_to do |format|
      format.html { redirect_to student_orgs_url, notice: "Student org was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_org
      @student_org = StudentOrg.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_org_params
      params.require(:student_org).permit(:name, :email, :full_name)
    end
end
